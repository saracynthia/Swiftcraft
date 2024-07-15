import 'dart:convert';

import 'package:ecommerce_app/src/cubit/orders/orders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;

import '../../../animations/fade_in.dart';
import '../../../cubit/cart/cart_cubit.dart';
import '../orders/orders_page.dart';

class CartBottomBar extends StatefulWidget {
  final double h;
  final double w;
  final TextEditingController voucherController;
  final double subTotal;
  final double shippingFee;
  final double total;

  const CartBottomBar({
    Key? key,
    required this.h,
    required this.w,
    required this.voucherController,
    required this.subTotal,
    required this.shippingFee,
    required this.total,
  }) : super(key: key);

  @override
  State<CartBottomBar> createState() => _CartBottomBarState();
}

class _CartBottomBarState extends State<CartBottomBar> {
  Map<String, dynamic>? paymentIntent;
  bool isPaying = false;

  void makePayment() async {
    try {
      setState(() {
        isPaying = true;
      });
      paymentIntent = await createPaymentIntent();

      var gpay = const PaymentSheetGooglePay(
        merchantCountryCode: 'US',
        currencyCode: "USD",
        testEnv: true,
      );

      // Initialize the payment sheet before presenting it
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          googlePay: gpay,
          merchantDisplayName: "SwiftCart",
        ),
      );

      // Now present the payment sheet
      displayPaymentSheet();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      // handle Navigation
      handleNavigation();
      setState(() {
        isPaying = false;
      });

      if (kDebugMode) {
        print("Done");
      }
    } catch (e, stackTrace) {
      setState(() {
        isPaying = false;
      });
      if (kDebugMode) {
        print("Error in displayPaymentSheet: $e");
        print("Stack Trace: $stackTrace");
      }
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent() async {
    try {
      Map<String, dynamic> body = {
        "amount": (widget.total.toInt() * 100).toString(),
        "currency": "USD",
      };
      http.Response response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: body,
        headers: {
          "Authorization":
              "Bearer sk_test_51Of0CpLzIYyZCEk1PYJ79wRU0vgrSmbwRhUpY9CVyB8CifwKRk9HaEozAoiMjkv2WiGN4ZXF1FliHYbZyIm30cEe00fCxHa9yN",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (kDebugMode) {
          print("$responseData");
        }
        return responseData;
      } else {
        if (kDebugMode) {
          print(
              "Failed to create payment intent. Status Code: ${response.statusCode}");
        }
        if (kDebugMode) {
          print("Response Body: ${response.body}");
        }
        throw Exception(
            "Failed to create payment intent. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  handleNavigation() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => const OrdersPage(),
      ),
    );
    context.read<CartCubit>().createOrderFromCart();
    context.read<OrdersCubit>().getAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      delay: 2,
      child: Container(
        height: widget.h * .23,
        width: widget.w,
        decoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(.1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: widget.w * .6,
                    height: widget.h * .035,
                    child: TextFormField(
                      controller: widget.voucherController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        hintText: 'Voucher code',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      try {
                        context.read<CartCubit>().applyVoucherCode(
                            widget.voucherController.text.trim());
                      } catch (e) {
                        if (kDebugMode) {
                          print(e);
                        }
                      }
                    },
                    child: Container(
                      height: widget.h * .035,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepPurple.withOpacity(.1),
                      ),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Text(
                                "Apply code",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Iconsax.tick_circle,
                                color: Colors.deepPurple,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Subtotal",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.deepPurple,
                    ),
                  ),
                  Text(
                    "\$ ${widget.subTotal.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Shipping",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.deepPurple,
                    ),
                  ),
                  Text(
                    "\$ ${widget.shippingFee.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.deepPurple,
                    ),
                  ),
                  Text(
                    "\$ ${widget.total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // GestureDetector(
                  //     onTap: () {

                  //       context.read<CartCubit>().deletedb();
                  //     },
                  //     child: Container(
                  //       height: widget.h * .05,
                  //       width: widget.w * .4,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(10),
                  //         color: Colors.deepPurple.withOpacity(.1),
                  //       ),
                  //       child: const Center(
                  //         child: Padding(
                  //           padding: EdgeInsets.symmetric(horizontal: 10),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Text(
                  //                 "deletedb",
                  //                 style: TextStyle(
                  //                   color: Colors.deepPurple,
                  //                   fontSize: 16,
                  //                 ),
                  //               ),
                  //               Icon(
                  //                 Iconsax.arrow_right_2,
                  //                 color: Colors.deepPurple,
                  //                 size: 20,
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  GestureDetector(
                    onTap: () {
                      makePayment();
                    },
                    child: Container(
                      height: widget.h * .05,
                      width: widget.w * .4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepPurple.withOpacity(.1),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: isPaying
                              ? const CupertinoActivityIndicator()
                              : const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Checkout",
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Icon(
                                      Iconsax.arrow_right_2,
                                      color: Colors.deepPurple,
                                      size: 20,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
