import 'package:flutter/material.dart';
import 'shop_skeleton.dart';

class ClothingPage extends StatefulWidget {
  const ClothingPage({Key? key}) : super(key: key);

  @override
  State<ClothingPage> createState() => _ClothingPageState();
}

class _ClothingPageState extends State<ClothingPage> {
  // Sample product entries with categories
  final List<Map<String, String>> _products = [
    {'name': 'T-Shirt', 'category': 'Clothing'},
    {'name': 'Hoodie', 'category': 'Clothing'},
    {'name': 'Sweatshirt', 'category': 'Clothing'},
    {'name': 'Jacket', 'category': 'Clothing'},
    {'name': 'Sports Top', 'category': 'Clothing'},
    {'name': 'Sticker Pack', 'category': 'Merchandise'},
    {'name': 'Mug', 'category': 'Merchandise'},
    {'name': 'Best Seller Tee', 'category': 'Popular'},
  ];

  String _filter = 'All';

  List<String> get _filteredNames {
    if (_filter == 'All') return _products.map((p) => p['name']!).toList();
    return _products
        .where((p) => p['category'] == _filter)
        .map((p) => p['name']!)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filterWidget = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text('FILTER BY: ', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: _filter,
          items: const [
            DropdownMenuItem(value: 'All', child: Text('All Products')),
            DropdownMenuItem(value: 'Clothing', child: Text('Clothing')),
            DropdownMenuItem(value: 'Merchandise', child: Text('Merchandise')),
            DropdownMenuItem(value: 'Popular', child: Text('Popular')),
          ],
          onChanged: (v) {
            if (v == null) return;
            setState(() => _filter = v);
          },
        ),
      ],
    );

    return ShopSkeleton(title: 'Clothing', items: _filteredNames, filterWidget: filterWidget);
  }
}
