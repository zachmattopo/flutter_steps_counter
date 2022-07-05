// ignore_for_file: sort_constructors_first

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_steps_counter/services/app_shared_preferences.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

part 'step_counter_event.dart';
part 'step_counter_state.dart';

class StepCounterBloc extends Bloc<StepCounterEvent, StepCounterState> {
  HealthFactory health = HealthFactory();

  StepCounterBloc() : super(StepCounterInitial()) {
    on<StepCounterEvent>((event, emit) async {
      if (event is StepCounterDataFetched) {
        emit(const StepCounterFetchInProgress());

        // Special handling for Android only
        if (Platform.isAndroid) {
          // On Android, health data is labeled as `dangerous` protection level,
          // the Android permission system will not grant it automatically and
          // it requires the user's action
          final permissionStatus = Permission.activityRecognition.request();

          if (await permissionStatus.isDenied ||
              await permissionStatus.isPermanentlyDenied) {
            // Permission denied, return with error state
            emit(
              const StepCounterFetchFailure(
                errorMessage:
                    // ignore: lines_longer_than_80_chars
                    'Activity permission is required to fetch your steps count.',
              ),
            );
            return;
          }
        }

        // List of data types and their respective desired permissions
        final types = [
          HealthDataType.STEPS,
          HealthDataType.ACTIVE_ENERGY_BURNED,
        ];

        // Check if we have permissions to access health data
        final hasPermissions = await HealthFactory.hasPermissions(
          types,
        );

        if (hasPermissions == null || !hasPermissions) {
          // Not permitted to get data, request permission
          final granted = await health.requestAuthorization(
            types,
          );

          if (!granted) {
            // Permission denied, return with error state
            emit(
              const StepCounterFetchFailure(
                errorMessage:
                    // ignore: lines_longer_than_80_chars
                    'Activity permission is required to fetch your steps count.',
              ),
            );
            return;
          }
        }

        // Get steps & calories for today (i.e. since midnight) from the plugin
        final now = DateTime.now();
        // TODO(hafiz): Remove the `-1` before sending to fastic
        final midnight = DateTime(now.year, now.month, now.day - 1);

        final healthDataList = await health.getHealthDataFromTypes(
          midnight,
          now,
          types,
        );

        // Count the steps and calories in the returned list
        var totalStepsDouble = 0.0;
        var totalCaloriesDouble = 0.0;

        for (final dataPoint in healthDataList) {
          if (dataPoint.type == HealthDataType.STEPS) {
            // Count as steps
            totalStepsDouble +=
                double.tryParse(dataPoint.value.toString()) ?? 0.0;
          } else if (dataPoint.type == HealthDataType.ACTIVE_ENERGY_BURNED) {
            // Count as calories
            totalCaloriesDouble +=
                double.tryParse(dataPoint.value.toString()) ?? 0.0;
          }
        }

        // Get number of daily goal steps set by user or the default
        final stepsGoal =
            await AppSharedPreferences.getInstance().getDailyGoalSteps();

        emit(
          StepCounterFetchSuccess(
            totalSteps: totalStepsDouble.round(),
            totalCalories: totalCaloriesDouble.round(),
            dailyGoalSteps: stepsGoal,
          ),
        );
      }
    });
  }
}
