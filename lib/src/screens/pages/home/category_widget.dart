import 'package:ecommerce_app/src/cubit/product/products_in_category/products_in_category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../animations/fade_in.dart';
import '../../../cubit/category/category_cubit.dart';
import '../../../cubit/selected_category/selected_category.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({
    Key? key,
    required this.h,
  }) : super(key: key);

  final double h;

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedIndexCubit, int>(
      builder: (context, state) {
        return BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, categoryState) {
            if (categoryState is CategoryLoading) {
              // Display loading indicator if categories are still loading
              return const CircularProgressIndicator();
            } else if (categoryState is CategoryLoaded) {
              // Display categories once loaded
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: SizedBox(
                  height: widget.h * 0.06,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: categoryState.categoyModel.length,
                    itemBuilder: (_, index) {
                      String categoryName =
                          categoryState.categoyModel[index].categoryName ??
                              "Unknown";
                      String capitalize(String input) {
                        if (input.isEmpty) {
                          return input;
                        }
                        return input[0].toUpperCase() + input.substring(1);
                      }

                      categoryName = capitalize(categoryName);
                      return GestureDetector(
                        onTap: () {
                          context.read<SelectedIndexCubit>().selectIndex(index);
                          context
                              .read<ProductsInCategoryCubit>()
                              .fetchProductsInCategory(
                                  category: categoryState
                                      .categoyModel[index].categoryName!);
                        },
                        child: FadeInAnimation(
                          delay: 1.5,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: state == index
                                    ? Colors.deepPurple
                                    : Colors.deepPurple
                                        .withOpacity(0.1), // Adjust as needed
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, left: 8),
                                child: Center(
                                  child: Text(
                                    categoryName,
                                    style: TextStyle(
                                      fontWeight: state == index
                                          ? FontWeight.bold
                                          : null,
                                      color: state == index
                                          ? Colors.white
                                          : Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else if (categoryState is CategoryError) {
              // Display an error message if fetching categories fails
              return Text("Error: ${categoryState.message}");
            } else {
              // Display a default state (e.g., initial state)
              return const Text("No data");
            }
          },
        );
      },
    );
  }
}
