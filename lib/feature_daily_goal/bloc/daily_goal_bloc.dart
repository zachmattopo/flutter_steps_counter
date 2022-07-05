// ignore_for_file: sort_constructors_first

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_steps_counter/feature_step_counter/counter.dart';
import 'package:flutter_steps_counter/services/repository.dart';

part 'daily_goal_event.dart';
part 'daily_goal_state.dart';

class DailyGoalBloc extends Bloc<DailyGoalEvent, DailyGoalState> {
  final StepCounterBloc stepCounterBloc;
  final Repository repository;

  DailyGoalBloc({
    required this.stepCounterBloc,
    required this.repository,
  }) : super(DailyGoalInitial()) {
    on<DailyGoalEvent>((event, emit) async {
      if (event is DailyGoalSet) {
        emit(const DailyGoalSetInProgress());

        // Update local daily step goals in shared pref
        await repository.setDailyGoalSteps(event.goal);

        // Get new steps counter data to check progress
        stepCounterBloc.add(const StepCounterDataFetched());

        emit(
          DailyGoalSetSuccess(
            goal: await repository.getDailyGoalSteps(),
          ),
        );
      }
    });
  }
}
