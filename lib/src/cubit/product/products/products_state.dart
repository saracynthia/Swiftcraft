part of 'products_cubit.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}

final class ProductsLoading extends ProductsState {}

final class ProductsLoaded extends ProductsState {
  final List<ProductModel> productModel;

  ProductsLoaded({required this.productModel});
}

final class ProductsError extends ProductsState {
  final String message;

  ProductsError({required this.message});
}
