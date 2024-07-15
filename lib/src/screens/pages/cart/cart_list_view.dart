import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconsax/iconsax.dart';

import '../../../animations/fade_in.dart';
import '../../../cubit/cart/cart_cubit.dart';

class CartListView extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartListView({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        double price =
            double.parse(cartItems[index]['price']) * cartItems[index]['count'];
        Color color = Color(int.parse(
          cartItems[index]['color'].split('(0x')[1].split(')')[0],
          radix: 16,
        ));

        return FadeInAnimation(
          delay: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(.2),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Slidable(
                endActionPane: ActionPane(
                  extentRatio: 0.25,
                  openThreshold: 0.25,
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      label: 'Delete',
                      onPressed: (context) {
                        try {
                          context.read<CartCubit>().deleteData(
                                cartItems[index]['id'],
                              );
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.deepPurple,
                                content: Text(
                                  "Removed item from cart",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                        } catch (e) {
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                      },
                      foregroundColor: Colors.red,
                      icon: Iconsax.trush_square,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CachedNetworkImage(
                          imageUrl: cartItems[index]['imageurl'],
                          imageBuilder: (context, imageProvider) => Container(
                            height: MediaQuery.of(context).size.height * .15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartItems[index]['title'],
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Text(
                                    'Color: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Text(
                                    'Size: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        .025,
                                    width:
                                        MediaQuery.of(context).size.width * .08,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.deepPurple.withOpacity(.1),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Text(
                                          cartItems[index]['size'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Text(
                                    'Total: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  Text(
                                    price.toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (cartItems[index]['count'] > 1) {
                                context.read<CartCubit>().updateData(
                                      cartItems[index]['id'],
                                      (cartItems[index]['count'] - 1)
                                          .toString(),
                                    );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.deepPurple.withOpacity(.1),
                              ),
                              width: MediaQuery.of(context).size.width * .075,
                              height: MediaQuery.of(context).size.height * .035,
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * .008),
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Center(
                                  child: Icon(
                                    Iconsax.minus,
                                    color: Colors.deepPurple,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              cartItems[index]['count'].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.read<CartCubit>().updateData(
                                    cartItems[index]['id'],
                                    (cartItems[index]['count'] + 1).toString(),
                                  );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.deepPurple.withOpacity(.1),
                              ),
                              width: MediaQuery.of(context).size.width * .075,
                              height: MediaQuery.of(context).size.height * .035,
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * .008),
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Center(
                                  child: Icon(
                                    Iconsax.add,
                                    color: Colors.deepPurple,
                                    size: 20,
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
            ),
          ),
        );
      },
    );
  }
}
