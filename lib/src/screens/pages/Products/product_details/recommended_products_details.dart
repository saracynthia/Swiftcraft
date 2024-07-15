import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubit/product/sorted_products/sorted_products_cubit.dart';
import 'details_page.dart';

class RecommendedProductsDetailsPage extends StatelessWidget {
  const RecommendedProductsDetailsPage({
    Key? key,
    required this.imageKey,
    required this.index,
  }) : super(key: key);

  final int index;
  final String imageKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SortedProductsCubit, SortedProductsState>(
      builder: (context, state) {
        if (state is SortedProductsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SortedProductsLoaded) {
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
