import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit()
      : super(CounterInitial(
          count: 1,
        ));

  void increment() {
    emit(CounterInitial(
      count: (state as CounterInitial).count + 1,
    ));
  }

  void decrement() {
    emit(CounterInitial(
      count: (state as CounterInitial).count - 1,
    ));
  }
}
