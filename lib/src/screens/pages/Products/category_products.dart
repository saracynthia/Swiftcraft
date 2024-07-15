import 'package:ecommerce_app/src/screens/pages/Products/product_card.dart';
import 'package:ecommerce_app/src/screens/pages/home/category_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../animations/fade_in.dart';
import '../../../cubit/product/products_in_category/products_in_category_cubit.dart';
import '../../../cubit/product/sorted_products/sorted_products_cubit.dart';
import 'product_details/category_product_details.dart';

class CategyProducts extends StatefulWidget {
  final double h;
  final double w;
  const CategyProducts({
    super.key,
    required this.h,
    required this.w,
  });

  @override
  State<CategyProducts> createState() => _CategyProductsState();
}

class _CategyProductsState extends State<CategyProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.deepPurple,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Category Products',
          style: TextStyle(
            color: Colors.deepPurple,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            CategoryWidget(
              h: widget.h,
            ),
            BlocBuilder<ProductsInCategoryCubit, ProductsInCategoryState>(
              builder: (context, state) {
                if (state is ProductsInCategoryLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ProductsInCategoryLoaded) {
                  return SizedBox(
                    height: widget.h * 0.8,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final String imageKey =
                            "Imagetag${state.products[index].id}";
                        return FadeInAnimation(
                          delay: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        CategoryProductsDetailsPage(
                                            imageKey: imageKey, index: index),
                                  ),
                                );
                              },
                              child: ProductCard(
                                image: state.products[index].image ?? '',
                                title: state.products[index].title ?? '',
                                imageKey: imageKey,
                                price: state.products[index].price ?? 0,
                                rating: double.parse(
                                  state.products[index].rating!.rate.toString(),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is SortedProductsError) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                } else {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
