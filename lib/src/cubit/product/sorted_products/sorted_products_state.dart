part of 'sorted_products_cubit.dart';

@immutable
sealed class SortedProductsState {}


final class SortedProductsInitial extends SortedProductsState {}

final class SortedProductsLoading extends SortedProductsState {}

final class SortedProductsLoaded extends SortedProductsState {
  final List<ProductModel> productModel;

  SortedProductsLoaded({required this.productModel});
}

final class SortedProductsError extends SortedProductsState {
  final String message;

  SortedProductsError({required this.message});
}