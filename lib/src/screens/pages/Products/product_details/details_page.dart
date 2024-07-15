import 'package:awesome_rating/awesome_rating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../animations/fade_in.dart';
import '../../../../cubit/cart/cart_cubit.dart';
import '../../../../database/cart_db_helper.dart';
import '../../../../model/fasion_model.dart';
import '../../../../utils/data.dart';

class DetailsContent extends StatefulWidget {
  const DetailsContent({
    Key? key,
    required this.imageKey,
    required this.index,
    required this.productModel,
  }) : super(key: key);

  final int index;
  final String imageKey;
  final ProductModel productModel;

  @override
  DetailsContentState createState() => DetailsContentState();
}

class DetailsContentState extends State<DetailsContent> {
  int selectedColor = 0;
  int selectedSize = 0;
  String selectedColorName = "S";
  int count = 1;

  List<Color> circleColors = [Colors.blue, Colors.green, Colors.red];

  void handleisSelectedColor(int index) {
    setState(() {
      selectedColor = index;
    });
  }

  void handleisSelectedSize(int index) {
    setState(() {
      selectedSize = index;
    });
  }

  void addCount() {
    setState(() {
      count = count + 1;
    });
  }

  void minusCount() {
    setState(() {
      if (count > 1) {
        count = count - 1;
      }
    });
  }

  Future<void> _addData() async {
    final cartCubit = context.read<CartCubit>();

    await SQLCartHealper.createData(
      widget.productModel.title ?? "",
      count,
      widget.productModel.price.toString(),
      widget.productModel.image ?? "",
      productSize[selectedSize].productSize,
      circleColors[selectedColor].toString(),
    );
    cartCubit.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    num totalPrice = widget.productModel.price! * count;
    return Scaffold(
      bottomNavigationBar: Container(
        height: h * .06,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Price",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "\$${totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  try {
                    _addData();
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.deepPurple,
                          content: Text(
                            "Item added to cart",
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
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Add to Cart",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Iconsax.shopping_cart,
                            color: Colors.white,
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
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite,
              color: Colors.deepPurple,
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Iconsax.arrow_left_2,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Hero(
                tag: Key(
                  widget.imageKey,
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.productModel.image ?? '',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.5),
                    blurRadius: 100,
                  ),
                ],
              ),
              child: FadeInAnimation(
                delay: 1,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        indent: w * .3,
                        endIndent: w * .3,
                        color: Colors.deepPurple,
                        thickness: 2,
                      ),
                      SizedBox(
                        height: h * .02,
                      ),
                      Text(
                        widget.productModel.title ?? "",
                        maxLines: 2,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: h * .02,
                      ),
                      Row(
                        children: [
                          AwesomeStarRating(
                            starCount: 5,
                            rating: 3.5,
                            size: h * 0.022,
                            color: Colors.deepPurple,
                            borderColor: Colors.deepPurple,
                            allowHalfRating: false,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.productModel.rating!.rate.toString(),
                            maxLines: 2,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: h * .02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Color:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: w * .4,
                            height: h * .035,
                            child: ListView.builder(
                              itemCount: 3,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (_, index) {
                                return GestureDetector(
                                  onTap: () {
                                    handleisSelectedColor(index);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: selectedColor == index
                                            ? Colors.black
                                            : Colors.transparent,
                                      ),
                                    ),
                                    width: w * .075,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: w * .008),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: circleColors[index],
                                        ),
                                        width: 15,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: h * .02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Size:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: w * .4,
                            height: h * .035,
                            child: ListView.builder(
                              itemCount: productSize.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (_, index) {
                                return GestureDetector(
                                  onTap: () {
                                    handleisSelectedSize(index);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: selectedSize == index
                                          ? Colors.deepPurple
                                          : Colors.deepPurple.withOpacity(.1),
                                    ),
                                    width: w * .075,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: w * .008),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Center(
                                        child: Text(
                                          productSize[index].productSize,
                                          style: TextStyle(
                                            color: selectedSize == index
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: h * .02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Quantity:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    minusCount();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.deepPurple.withOpacity(.1),
                                    ),
                                    width: w * .075,
                                    height: h * .035,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: w * .008),
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
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: Text(
                                    count.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    addCount();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.deepPurple.withOpacity(.1),
                                    ),
                                    width: w * .075,
                                    height: h * .035,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: w * .008),
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
                          ),
                        ],
                      ),
                      SizedBox(
                        height: h * .02,
                      ),
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        widget.productModel.description.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
