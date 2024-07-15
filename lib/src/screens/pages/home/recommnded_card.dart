import 'package:awesome_rating/awesome_rating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../animations/fade_in.dart';
import '../../../cubit/product/sorted_products/sorted_products_cubit.dart';
import '../Products/product_details/recommended_products_details.dart';

class RecommendedCard extends StatelessWidget {
  final double h;
  final double w;

  const RecommendedCard({
    super.key,
    required this.h,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    // final sortedProductsCubit = context.read<SortedProductsCubit>();
    // sortedProductsCubit.fetchSortedProducts();
    return BlocBuilder<SortedProductsCubit, SortedProductsState>(
      builder: (context, state) {
        if (state is SortedProductsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SortedProductsLoaded) {
          return FadeInAnimation(
            delay: 2,
            child: SizedBox(
              height: h * 0.3,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: state.productModel.map(
                    (product) {
                      final String imageKey =
                          "RecommendedImagetag${product.id}";
                      var index = state.productModel.indexOf(product);

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    RecommendedProductsDetailsPage(
                                        imageKey: imageKey, index: index),
                              ),
                            );
                          },
                          child: Container(
                            width: w * .5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurple.withOpacity(0.3),
                                  spreadRadius: .5,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Hero(
                                      tag: Key(
                                        imageKey,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: product.image ?? '',
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title ?? '',
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "\$${product.price.toString()}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.deepPurple,
                                            ),
                                          ),
                                          AwesomeStarRating(
                                            starCount: 5,
                                            rating: double.parse(
                                              product.rating!.rate.toString(),
                                            ),
                                            size: h * 0.02,
                                            color: Colors.deepPurple,
                                            borderColor: Colors.deepPurple,
                                            allowHalfRating: false,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: Text("Error"),
          );
        }
      },
    );
  }
}
