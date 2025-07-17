import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool isLoading = false;

  List<Product> get products => _products;

  Future<void> loadProducts() async {
    isLoading = true;
    notifyListeners();

    _products = await ApiService.fetchProducts();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addProduct(Product p) async {
    await ApiService.createProduct(p);
    await loadProducts();
  }

  Future<void> updateProduct(int id, Product p) async {
    await ApiService.updateProduct(id, p);
    await loadProducts();
  }

  Future<void> deleteProduct(int id) async {
    await ApiService.deleteProduct(id);
    await loadProducts();
  }
}
