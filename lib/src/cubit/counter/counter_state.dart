part of 'counter_cubit.dart';

@immutable
abstract class CounterState {}

class CounterInitial extends CounterState {
  final int count;

  CounterInitial({
    required this.count,
  });
}

class CounterError extends CounterState {
  final String message;

  CounterError({required this.message});
}
