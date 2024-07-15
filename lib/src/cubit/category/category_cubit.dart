import 'package:bloc/bloc.dart';

import '../../api/fasion_api_provider.dart';
import '../../model/fasion_model.dart'; // Import your CategoryModel

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  Future<void> fetchCategories() async {
    emit(CategoryLoading());

    try {
      // Assume you have a CategoryApiProvider instance
      final apiProvider = CategoryApiProvider();
      final categories = await apiProvider.getCategoryItems();

      emit(CategoryLoaded(categoyModel: categories));
    } catch (e) {
      emit(CategoryError(message: 'Failed to fetch categories'));
    }
  }
}