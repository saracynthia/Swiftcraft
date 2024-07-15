part of 'category_cubit.dart';

sealed class CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategoryInitial extends CategoryState {}

final class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categoyModel;

  CategoryLoaded({required this.categoyModel});

  
}

final class CategoryError extends CategoryState {
  final String message;

  CategoryError({required this.message});
}
