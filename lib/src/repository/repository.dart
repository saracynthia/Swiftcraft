
import '../api/fasion_api_provider.dart';
import '../model/fasion_model.dart';

class ProductRepository {
  final _apiProvider = ProductApiProvider();
  Future<List<ProductModel>> getProductItems() async {
    return _apiProvider.getProductItems();
  }
}
class SortedProductRepository {
  final _apiProvider = SortedProductApiProvider();
  Future<List<ProductModel>> getProductItems() async {
    return _apiProvider.getSortedProductItems();
  }
}

class GetProductsFromCategoryRepository {
  final _apiProvider = GetProductsInCategory();
  Future<List<ProductModel>> getProductItems({required String category}) async {
    return _apiProvider.getProductsInCategory(category: category);
  }
}

class CategoryRepository {
  final _apiProvider = CategoryApiProvider();
  Future<List<CategoryModel>> getCategoryItems() async {
    return _apiProvider.getCategoryItems();
  }
}
