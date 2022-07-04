part of 'daily_goal_bloc.dart';

abstract class DailyGoalEvent extends Equatable {
  const DailyGoalEvent();

  @override
  List<Object> get props => [];
}

class DailyGoalSet extends DailyGoalEvent {
  const DailyGoalSet({required this.goal});

  final int goal;

  @override
  List<Object> get props => [goal];

  @override
  String toString() => 'DailyGoalSet { goal : $goal }';
}
