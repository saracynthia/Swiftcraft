import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubit/product/products_in_category/products_in_category_cubit.dart';
import 'details_page.dart';

class CategoryProductsDetailsPage extends StatelessWidget {
  const CategoryProductsDetailsPage({
    Key? key,
    required this.imageKey,
    required this.index,
  }) : super(key: key);

  final int index;
  final String imageKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsInCategoryCubit, ProductsInCategoryState>(
      builder: (context, state) {
        if (state is ProductsInCategoryLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ProductsInCategoryLoaded) {
          return DetailsContent(
            index: index,
            imageKey: imageKey,
            productModel: state.products[index],
          );
        }
        return const Center(
          child: Text('Something went wrong'),
        );
      },
    );
  }
}
