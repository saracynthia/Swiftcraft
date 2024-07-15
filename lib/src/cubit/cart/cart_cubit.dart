import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../database/cart_db_helper.dart';
import '../../database/orders_db_helper.dart';

abstract class CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<Map<String, dynamic>> allData;
  final bool isVoucherApplied;
  final double voucherCode;
  final double shippingFee;

  CartLoaded({
    this.allData = const [],
    this.isVoucherApplied = false,
    this.voucherCode = 0,
    this.shippingFee = 8.22,
  });

  CartLoaded copyWith({
    List<Map<String, dynamic>>? allData,
    bool? isVoucherApplied,
    double? voucherCode,
    double? shippingFee,
    double? delayAmount,
  }) {
    return CartLoaded(
      allData: allData ?? this.allData,
      isVoucherApplied: isVoucherApplied ?? this.isVoucherApplied,
      voucherCode: voucherCode ?? this.voucherCode,
      shippingFee: shippingFee ?? this.shippingFee,
    );
  }
}

class CartCubit extends Cubit<CartState> {
  CartCubit()
      : super(CartLoaded(allData: [], isVoucherApplied: false, voucherCode: 0));

  void refreshData() async {
    final data = await SQLCartHealper.getAllData();
    emit((state as CartLoaded).copyWith(allData: data));
  }

  Future<void> updateData(int id, String count) async {
    await SQLCartHealper.updateData(id, int.parse(count));
    refreshData();
  }

  Future<void> deleteData(int id) async {
    await SQLCartHealper.deleteData(id);
    refreshData();
  }

  Future<void> deletedb() async {
    await SQLOrderHelper.deleteDatabase();
    if (kDebugMode) {
      print("Done");
    }
  }

  Future<void> createOrderFromCart() async {
    final cartData = (state as CartLoaded).allData;
    final total = this.total();
    DateTime now = DateTime.now();

    String formattedDate = DateFormat.yMMMMd('en_US').format(now);

    // Ensure there is data in the cart
    if (cartData.isEmpty) {
      return;
    }

    // Debug print to check cart data before creating the order
    if (kDebugMode) {
      print('Cart Data: $cartData');
    }
    final orderNumber = "ORDSC${DateTime.now().microsecond}";

    // Create a list of items from cart data
    List<Item> items = cartData.map((cartItem) {
      return Item(
        title: cartItem['title'],
        price: (cartItem['price'] is int)
            ? (cartItem['price'] as int).toDouble()
            : double.parse(cartItem['price'].toString()),
        imageUrl: cartItem['imageurl'],
        count: cartItem['count'].toString(),
        size: cartItem['size'],
        color:cartItem['color'],
      );
    }).toList();

    // Create an order object with items
    final order = Order(
      createdAt: formattedDate.toString(),
      orderNumber: orderNumber,
      items: items,
      total: total.toString(),
    );

    // Debug print to check items before inserting into the database
    for (var item in items) {
      if (kDebugMode) {
        print('Item: ${item.title} - ${item.price}');
      }
    }

    // Insert the order into the orders database
    await SQLOrderHelper.createOrder(order);

    // Clear the cart data
    emit(CartLoaded(
      allData: [],
      isVoucherApplied: false,
      voucherCode: 0,
      shippingFee: 8.22,
    ));
    // Do not delete the cart data if you want to keep it for reference
    await SQLCartHealper.deleteDatabase();
  }

  void applyVoucherCode(String code) {
    if (code.trim() == 'CALCODE' && !(state as CartLoaded).isVoucherApplied) {
      emit((state as CartLoaded)
          .copyWith(voucherCode: 10, isVoucherApplied: true));
    } else {
      emit((state as CartLoaded)
          .copyWith(voucherCode: 0, isVoucherApplied: false));
    }
  }

  double subTotal() {
    double total = 0;
    for (int i = 0; i < (state as CartLoaded).allData.length; i++) {
      total += double.parse((state as CartLoaded).allData[i]['price']) *
          (state as CartLoaded).allData[i]['count'];
    }
    return total;
  }

  double total() {
    double subTotal = this.subTotal();
    if (subTotal == 0) {
      return 0;
    } else {
      return subTotal +
          (state as CartLoaded).shippingFee -
          (state as CartLoaded).voucherCode;
    }
  }
}
