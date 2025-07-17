import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name, price, stock;

  @override
  void initState() {
    super.initState();
    name = widget.product.name;
    price = widget.product.price.toString();
    stock = widget.product.stock.toString();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              initialValue: name,
              decoration: const InputDecoration(labelText: 'Product Name'),
              validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              onSaved: (val) => name = val!,
            ),
            TextFormField(
              initialValue: price,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              validator: (val) => val == null || double.tryParse(val) == null ? 'Enter valid price' : null,
              onSaved: (val) => price = val!,
            ),
            TextFormField(
              initialValue: stock,
              decoration: const InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
              validator: (val) => val == null || int.tryParse(val) == null ? 'Enter valid stock' : null,
              onSaved: (val) => stock = val!,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Save Changes'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final updated = Product(
                    id: widget.product.id,
                    name: name,
                    price: double.parse(price),
                    stock: int.parse(stock),
                  );
                  await provider.updateProduct(updated.id, updated);
                  Navigator.pop(context);
                }
              },
            ),
          ]),
        ),
      ),
    );
  }
}
