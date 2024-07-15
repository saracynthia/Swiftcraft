import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/src/model/fasion_model.dart';
import 'package:meta/meta.dart';

import '../../../api/fasion_api_provider.dart';

part 'products_in_category_state.dart';

class ProductsInCategoryCubit extends Cubit<ProductsInCategoryState> {
  ProductsInCategoryCubit() : super(ProductsInCategoryInitial());

  Future<void> fetchProductsInCategory({required String category}) async {
    emit(ProductsInCategoryLoading());

    try {
      // Assume you have a ProductApiProvider instance
      final apiProvider = GetProductsInCategory();
      final products =
          await apiProvider.getProductsInCategory(category: category);

      emit(ProductsInCategoryLoaded(products: products));
    } catch (e) {
      emit(ProductsInCategoryError(message: 'Failed to fetch products'));
    }
  }
}
