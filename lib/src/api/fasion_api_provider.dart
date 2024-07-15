// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'dart:developer' as developer;

import '../model/fasion_model.dart';

class ProductApiProvider {
  final _dio = Dio();
  static const productUrl = 'https://fakestoreapi.com/products';

  final List<ProductModel> _products = [];

  Future<List<ProductModel>> getProductItems() async {
    try {
      Response response = await _dio.get(productUrl);
      _products.addAll(
          List.from(response.data).map((e) => ProductModel.fromJson(e)));
      return _products;
    } catch (e) {
      developer.log(e.toString());
      return [];
    }
  }
}

class SortedProductApiProvider {
  final _dio = Dio();
  static const productUrl = 'https://fakestoreapi.com/products?sort=desc';

  final List<ProductModel> _products = [];

  Future<List<ProductModel>> getSortedProductItems() async {
    try {
      Response response = await _dio.get(productUrl);
      _products.addAll(
          List.from(response.data).map((e) => ProductModel.fromJson(e)));
      return _products;
    } catch (e) {
      developer.log(e.toString());
      return [];
    }
  }
}

class GetProductsInCategory {
  final _dio = Dio();
  static const productUrl = 'https://fakestoreapi.com/products/category/';

  final List<ProductModel> _products = [];

  Future<List<ProductModel>> getProductsInCategory(
      {required String category}) async {
    try {
      Response response = await _dio.get(productUrl + category);
      _products.addAll(
          List.from(response.data).map((e) => ProductModel.fromJson(e)));
      return _products;
    } catch (e) {
      developer.log(e.toString());
      return [];
    }
  }
}

class CategoryApiProvider {
  final _dio = Dio();
  String categoryUrl = 'https://fakestoreapi.com/products/categories';

  Future<List<CategoryModel>> getCategoryItems() async {
    try {
      Response response = await _dio.get(categoryUrl);

      List<CategoryModel> categories = List.from(response.data)
          .map((json) => CategoryModel.fromJson(json))
          .toList();

      return categories;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
