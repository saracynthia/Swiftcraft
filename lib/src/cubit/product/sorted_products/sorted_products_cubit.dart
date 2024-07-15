import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../api/fasion_api_provider.dart';
import '../../../model/fasion_model.dart';

part 'sorted_products_state.dart';

class SortedProductsCubit extends Cubit<SortedProductsState> {
  SortedProductsCubit() : super(SortedProductsInitial());

  Future<void> fetchSortedProducts() async {
    emit(SortedProductsLoading());

    try {
      // Assume you have a ProductApiProvider instance
      final apiProvider = SortedProductApiProvider();
      final products = await apiProvider.getSortedProductItems();

      emit(SortedProductsLoaded(productModel: products));
    } catch (e) {
      emit(SortedProductsError(message: 'Failed to fetch products'));
    }
  }

 
}
