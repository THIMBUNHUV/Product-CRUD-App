import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  // static const baseUrl = 'http://10.0.2.2:5000/products';

  static const baseUrl = 'http://192.168.100.18:5000/products';

  static Future<List<Product>> fetchProducts() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      List data = json.decode(res.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<void> createProduct(Product p) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(p.toJson()),
    );
    if (res.statusCode != 201) throw Exception('Create failed');
  }

  static Future<void> updateProduct(int id, Product p) async {
    final res = await http.put(
      Uri.parse('$baseUrl?id=$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(p.toJson()),
    );
    if (res.statusCode != 200) throw Exception('Update failed');
  }

  static Future<void> deleteProduct(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl?id=$id'));
    if (res.statusCode != 200) throw Exception('Delete failed');
  }
}
