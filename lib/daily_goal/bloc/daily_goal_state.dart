part of 'daily_goal_bloc.dart';

abstract class DailyGoalState extends Equatable {
  const DailyGoalState();

  @override
  List<Object> get props => [];
}

class DailyGoalInitial extends DailyGoalState {}

class DailyGoalSetInProgress extends DailyGoalState {
  const DailyGoalSetInProgress();

  @override
  String toString() => 'DailyGoalSetInProgress';
}

class DailyGoalSetSuccess extends DailyGoalState {
  const DailyGoalSetSuccess({required this.goal});

  final int goal;

  @override
  List<Object> get props => [goal];

  @override
  String toString() => 'DailyGoalSetSuccess { goal: $goal }';
}

class DailyGoalSetFailure extends DailyGoalState {
  const DailyGoalSetFailure({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'DailyGoalSetFailure { errorMessage: $errorMessage }';
}
