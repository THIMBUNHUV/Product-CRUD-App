import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String price = '';
  String stock = '';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator:
                    (val) => val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => name = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator:
                    (val) =>
                        val == null || double.tryParse(val) == null
                            ? 'Enter valid price'
                            : null,
                onSaved: (val) => price = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator:
                    (val) =>
                        val == null || int.tryParse(val) == null
                            ? 'Enter valid stock'
                            : null,
                onSaved: (val) => stock = val!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Submit'),

                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final product = Product(
                      id: 0, 
                      name: name,
                      price: double.parse(price),
                      stock: int.parse(stock),
                    );
                    await provider.addProduct(
                      product,
                    ); 
                    
                    Navigator.pop(context); 
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
