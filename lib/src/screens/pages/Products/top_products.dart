import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../animations/fade_in.dart';
import '../../../cubit/product/products/products_cubit.dart';
import 'product_details/top_products_details.dart';
import 'product_card.dart';


class TopProducts extends StatelessWidget {
  final double h;
  final double w;

  const TopProducts({
    super.key,
    required this.h,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ProductsLoaded) {
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
                'Top Products',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: state.productModel.length,
              itemBuilder: (context, index) {
                final String imageKey =
                    "Imagetag${state.productModel[index].id}";
                return FadeInAnimation(
                  delay: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => TopProductsDetailsPage(
                                imageKey: imageKey, index: index),
                          ),
                        );
                      },
                      child: ProductCard(
                        image: state.productModel[index].image ?? '',
                        title: state.productModel[index].title ?? '',
                        imageKey: imageKey,
                        price: state.productModel[index].price ?? 0,
                        rating: double.parse(
                          state.productModel[index].rating!.rate.toString(),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const Center(
          child: Text('Something went wrong'),
        );
      },
    );
  }
}
