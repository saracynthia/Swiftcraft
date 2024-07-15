import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubit/product/products/products_cubit.dart';
import 'details_page.dart';


class TopProductsDetailsPage extends StatelessWidget {
  const TopProductsDetailsPage({
    Key? key,
    required this.imageKey,
    required this.index,
  }) : super(key: key);

  final int index;
  final String imageKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ProductsLoaded) {
          return DetailsContent(
            index: index,
            imageKey: imageKey,
            productModel: state.productModel[index],
          );
        }
        return const Center(
          child: Text('Something went wrong'),
        );
      },
    );
  }
}
