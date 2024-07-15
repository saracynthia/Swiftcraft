import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../api/fasion_api_provider.dart';
import '../../../model/fasion_model.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());

  Future<void> fetchProducts() async {
    emit(ProductsLoading());

    try {
      // Assume you have a ProductApiProvider instance
      final apiProvider = ProductApiProvider();
      final products = await apiProvider.getProductItems();

      emit(ProductsLoaded(productModel: products));
    } catch (e) {
      emit(ProductsError(message: 'Failed to fetch products'));
    }
  }
}
