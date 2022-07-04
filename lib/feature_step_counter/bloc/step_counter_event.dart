part of 'step_counter_bloc.dart';

abstract class StepCounterEvent extends Equatable {
  const StepCounterEvent();

  @override
  List<Object> get props => [];
}

class StepCounterDataFetched extends StepCounterEvent {
  const StepCounterDataFetched();

  @override
  String toString() => 'StepCounterDataFetched';
}
