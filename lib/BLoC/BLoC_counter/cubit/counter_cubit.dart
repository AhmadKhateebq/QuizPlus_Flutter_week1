import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<double> {
  CounterCubit() : super(1);
  void increment() => emit(state * 2.5);
  void decrement() => emit(state / 2);
}