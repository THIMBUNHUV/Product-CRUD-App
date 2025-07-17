import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_tile.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductState();
}

class _ProductState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _searchText = '';
  String _sortType = 'None';
  int _currentPage = 1;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _currentPage++;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    List filtered =
        _searchText.isEmpty
            ? provider.products
            : provider.products
                .where(
                  (p) =>
                      p.name.toLowerCase().contains(_searchText.toLowerCase()),
                )
                .toList();
    if (_sortType == 'Price') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortType == 'Stock') {
      filtered.sort((a, b) => a.stock.compareTo(b.stock));
    }

    final paginated = filtered.take(_currentPage * _pageSize).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          _buildSearchAndSort(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => provider.loadProducts(),
              child:
                  provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : paginated.isEmpty
                      ? const _EmptyProducts()
                      : _buildProductList(paginated, provider),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddProductScreen()),
            ),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  Widget _buildSearchAndSort() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (val) {
                setState(() {
                  _searchText = val;
                  _currentPage = 1;
                });
              },
            ),
          ),
          const SizedBox(width: 10),
          DropdownButton<String>(
            value: _sortType,
            items:
                ['None', 'Price', 'Stock']
                    .map(
                      (e) =>
                          DropdownMenuItem(value: e, child: Text('Sort by $e')),
                    )
                    .toList(),
            onChanged: (val) {
              setState(() {
                _sortType = val!;
                _currentPage = 1;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(List paginated, ProductProvider provider) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: paginated.length,
      itemBuilder: (context, index) {
        final product = paginated[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ProductTile(
            product: product,
            onEdit: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProductScreen(product: product),
                ),
              );
            },

            onDelete: () {
              Future.microtask(() {
                showDialog(
                  context: context,
                  builder:
                      (dialogContext) => AlertDialog(
                        title: const Text('Delete Product'),
                        content: Text(
                          'Are you sure you want to delete "${product.name}"?',
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.of(dialogContext).pop(),
                          ),
                          TextButton(
                            child: const Text('Delete'),
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              provider.deleteProduct(product.id);
                            },
                          ),
                        ],
                      ),
                );
              });
            },
          ),
        );
      },
    );
  }
}

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2, size: 80, color: Colors.indigo[400]),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 20,
              color: Colors.indigo[400],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add one',
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
