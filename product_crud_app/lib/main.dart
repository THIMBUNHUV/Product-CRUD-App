import 'package:flutter/material.dart';
import 'package:product_crud_app/screens/product_list_screen.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductProvider()..loadProducts(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product CRUD App',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const ProductListScreen(),
    );
  }
}
