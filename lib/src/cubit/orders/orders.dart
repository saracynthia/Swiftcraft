import 'package:flutter_bloc/flutter_bloc.dart';

import '../../database/orders_db_helper.dart';

abstract class OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<Order> allData;

  OrdersLoaded(this.allData);
}

class OrdersError extends OrdersState {}

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersLoading());

  void getAllOrders() async {
    try {
      final allData = await SQLOrderHelper.getAllOrders();
      emit(OrdersLoaded(allData));
    } catch (e) {
      emit(OrdersError());
    }
  }
}