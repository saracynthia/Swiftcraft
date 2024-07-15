import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../cubit/cart/cart_cubit.dart';
import 'cart_bottom_bar.dart';
import 'cart_list_view.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  final TextEditingController _voucherController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is CartLoaded) {
          return Scaffold(
            bottomNavigationBar: context.read<CartCubit>().subTotal() == 0
                ? const SizedBox.shrink()
                : CartBottomBar(
                    h: h,
                    w: w,
                    voucherController: _voucherController,
                    subTotal: context.read<CartCubit>().subTotal(),
                    shippingFee: state.shippingFee,
                    total: context.read<CartCubit>().total(),
                  ),
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                "My Cart ",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: state.allData.isEmpty
                ? Center(
                  child: Lottie.network(
                    height: h * .4,
                    'https://raw.githubusercontent.com/saracynthia/e-commerce-app/main/lottie/emptycart.json',
                  ),
                )
                : CartListView(cartItems: state.allData),
          );
        }
        return const Text("Error");
      },
    );
  }
}
