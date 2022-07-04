part of 'step_counter_bloc.dart';

abstract class StepCounterState extends Equatable {
  const StepCounterState();

  @override
  List<Object> get props => [];
}

class StepCounterInitial extends StepCounterState {}

class StepCounterFetchInProgress extends StepCounterState {
  const StepCounterFetchInProgress();

  @override
  String toString() => 'StepCounterFetchInProgress';
}

class StepCounterFetchSuccess extends StepCounterState {
  const StepCounterFetchSuccess({
    required this.totalSteps,
    required this.totalCalories,
    required this.dailyGoalSteps,
  });

  /// Total steps for the day (i.e. midnight - now).
  final int totalSteps;

  /// Total steps for the day (i.e. midnight - now).
  final int totalCalories;

  /// Daily goal for steps set by user.
  final int dailyGoalSteps;

  @override
  List<Object> get props => [
        totalSteps,
        totalCalories,
        dailyGoalSteps,
      ];

  @override
  String toString() =>
      // ignore: lines_longer_than_80_chars
      'StepCounterFetchSuccess { totalSteps: $totalSteps, totalCalories: $totalCalories, dailyGoalSteps: $dailyGoalSteps }';
}

class StepCounterFetchFailure extends StepCounterState {
  const StepCounterFetchFailure({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() =>
      'StepCounterFetchFailure { errorMessage: $errorMessage }';
}
