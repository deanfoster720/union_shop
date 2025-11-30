import 'package:flutter/material.dart';
import 'shop_skeleton.dart';

class ClothingPage extends StatefulWidget {
  const ClothingPage({Key? key}) : super(key: key);

  @override
  State<ClothingPage> createState() => _ClothingPageState();
}

class _ClothingPageState extends State<ClothingPage> {
  // Sample product entries with categories and prices
  final List<Map<String, dynamic>> _products = [
    {'name': 'T-Shirt', 'category': 'Clothing', 'price': 12.99},
    {'name': 'Hoodie', 'category': 'Clothing', 'price': 29.99},
    {'name': 'Sweatshirt', 'category': 'Clothing', 'price': 24.5},
    {'name': 'Jacket', 'category': 'Clothing', 'price': 49.99},
    {'name': 'Sports Top', 'category': 'Clothing', 'price': 18.0},
    {'name': 'Sticker Pack', 'category': 'Merchandise', 'price': 4.99},
    {'name': 'Mug', 'category': 'Merchandise', 'price': 7.5},
    {'name': 'Best Seller Tee', 'category': 'Popular', 'price': 15.0},
  ];

  String _filter = 'All';
  String _sort = 'None';

  // Returns the filtered list of product maps (not sorted)
  List<Map<String, dynamic>> get _filteredProducts {
    if (_filter == 'All') return List.from(_products);
    return _products.where((p) => p['category'] == _filter).toList();
  }

  // Returns the filtered product names after applying the selected sort
  List<String> get _filteredNames {
    final list = _filteredProducts;
    if (_sort == 'Price: Low to High') {
      list.sort(
          (a, b) => (a['price'] as double).compareTo(b['price'] as double));
    } else if (_sort == 'Price: High to Low') {
      list.sort(
          (a, b) => (b['price'] as double).compareTo(a['price'] as double));
    }
    return list.map((p) => p['name'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filterWidget = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text('FILTER BY: ',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: _filter,
              items: const [
                DropdownMenuItem(value: 'All', child: Text('All Products')),
                DropdownMenuItem(value: 'Clothing', child: Text('Clothing')),
                DropdownMenuItem(
                    value: 'Merchandise', child: Text('Merchandise')),
                DropdownMenuItem(value: 'Popular', child: Text('Popular')),
              ],
              onChanged: (v) {
                if (v == null) return;
                setState(() => _filter = v);
              },
            ),
          ],
        ),

        // Sort control on the right
        Row(
          children: [
            const Text('SORT BY: ',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: _sort,
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
          ],
        ),
      ],
    );

    return ShopSkeleton(
        title: 'Clothing', items: _filteredNames, filterWidget: filterWidget);
  }
}
