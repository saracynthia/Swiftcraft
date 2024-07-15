part of 'products_in_category_cubit.dart';

@immutable
sealed class ProductsInCategoryState {}

final class ProductsInCategoryInitial extends ProductsInCategoryState {}

final class ProductsInCategoryLoading extends ProductsInCategoryState {}

final class ProductsInCategoryLoaded extends ProductsInCategoryState {
  final List<ProductModel> products;
  ProductsInCategoryLoaded({
    required this.products,
  });
}

final class ProductsInCategoryError extends ProductsInCategoryState {
  final String message;
  ProductsInCategoryError({
    required this.message,
  });
}
