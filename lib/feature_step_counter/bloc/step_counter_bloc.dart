// ignore_for_file: sort_constructors_first

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_steps_counter/services/repository.dart';

part 'step_counter_event.dart';
part 'step_counter_state.dart';

class StepCounterBloc extends Bloc<StepCounterEvent, StepCounterState> {
  final Repository repository;

  StepCounterBloc({required this.repository}) : super(StepCounterInitial()) {
    on<StepCounterEvent>((event, emit) async {
      if (event is StepCounterDataFetched) {
        emit(const StepCounterFetchInProgress());

        final isSpecialPermissionGranted =
            await repository.checkSpecialPermission();

        if (!isSpecialPermissionGranted) {
          // Permission denied, return with error state
          emit(
            const StepCounterFetchFailure(
              errorMessage:
                  'Activity permission is required to fetch your steps count.',
            ),
          );
          return;
        }

        final isHealthPermissionGranted =
            await repository.checkHealthAccessPermission();

        if (!isHealthPermissionGranted) {
          // Permission denied, return with error state
          emit(
            const StepCounterFetchFailure(
              errorMessage:
                  'Activity permission is required to fetch your steps count.',
            ),
          );
          return;
        }

        final healthDataMap = await repository.getHealthData();

        // Get number of daily goal steps set by user or the default
        final stepsGoal = await repository.getDailyGoalSteps();

        emit(
          StepCounterFetchSuccess(
            totalSteps: healthDataMap['totalSteps'] ?? 0,
            totalCalories: healthDataMap['totalCalories'] ?? 0,
            dailyGoalSteps: stepsGoal,
          ),
        );
      }
    });
  }
}
