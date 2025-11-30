import 'package:flutter/material.dart';
import 'shop_skeleton.dart';
import '../repositories/product_repository.dart';
import '../models/product.dart';

class ClothingPage extends StatefulWidget {
  const ClothingPage({Key? key}) : super(key: key);

  @override
  State<ClothingPage> createState() => _ClothingPageState();
}

class _ClothingPageState extends State<ClothingPage> {
  // Products sourced from the repository
  List<Product> _allProducts = [];

  String _filter = 'All';
  String _sort = 'None';

  @override
  void initState() {
    super.initState();
    // Synchronous fetch; repository provides both sync and async variations.
    _allProducts = ProductRepository.instance.fetchAll();
  }

  String _categoryOf(Product p) {
    final name = p.name.toLowerCase();
    if (p.discountedPrice != null || name.contains('best seller'))
      return 'Popular';
    const clothingKeywords = [
      'hoodie',
      't-shirt',
      'tshirt',
      'tee',
      'sweatshirt',
      'jacket',
      'sports'
    ];
    for (final k in clothingKeywords) {
      if (name.contains(k)) return 'Clothing';
    }
    const merchKeywords = [
      'postcard',
      'magnet',
      'bookmark',
      'notebook',
      'mug',
      'sticker',
      'pack'
    ];
    for (final k in merchKeywords) {
      if (name.contains(k)) return 'Merchandise';
    }
    // Fallback to Clothing
    return 'Clothing';
  }

  double _priceOf(Product p) => p.discountedPrice ?? p.price;

  // Returns the filtered list of products (not sorted)
  List<Product> get _filteredProducts {
    if (_filter == 'All') return List.from(_allProducts);
    return _allProducts.where((p) => _categoryOf(p) == _filter).toList();
  }

  // Returns the filtered product names after applying the selected sort
  List<String> get _filteredNames {
    final list = _filteredProducts;
    if (_sort == 'Price: Low to High') {
      list.sort((a, b) => _priceOf(a).compareTo(_priceOf(b)));
    } else if (_sort == 'Price: High to Low') {
      list.sort((a, b) => _priceOf(b).compareTo(_priceOf(a)));
    }
    return list.map((p) => p.name).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Compact, centered filter + sort widget to avoid overflowing on small screens
    final filterWidget = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // FILTER
            Row(
              children: [
                const Text('FILTER BY: ',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(width: 6),
                SizedBox(
                  width: 160,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _filter,
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                    items: const [
                      DropdownMenuItem(
                          value: 'All', child: Text('All Products')),
                      DropdownMenuItem(
                          value: 'Clothing', child: Text('Clothing')),
                      DropdownMenuItem(
                          value: 'Merchandise', child: Text('Merchandise')),
                      DropdownMenuItem(
                          value: 'Popular', child: Text('Popular')),
                    ],
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() => _filter = v);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),

            // SORT
            Row(
              children: [
                const Text('SORT BY: ',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(width: 6),
                SizedBox(
                  width: 160,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _sort,
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                    items: const [
                      DropdownMenuItem(value: 'None', child: Text('None')),
                      DropdownMenuItem(
                          value: 'Price: Low to High',
                          child: Text('Price: Low → High')),
                      DropdownMenuItem(
                          value: 'Price: High to Low',
                          child: Text('Price: High → Low')),
                    ],
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() => _sort = v);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return ShopSkeleton(
        title: 'Clothing', items: _filteredNames, filterWidget: filterWidget);
  }
}
