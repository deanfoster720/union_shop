import 'package:flutter/material.dart';
import 'package:union_shop/features/products/models/product.dart';
import 'package:union_shop/features/products/repositories/product_repository.dart';

import 'shop_skeleton.dart';

class ClothingPage extends StatefulWidget {
  const ClothingPage({Key? key}) : super(key: key);

  @override
  State<ClothingPage> createState() => _ClothingPageState();
}

class _ClothingPageState extends State<ClothingPage> {
  // Products sourced from the repository
  List<Product> _allProducts = [];

  @override
  void initState() {
    super.initState();
    // Synchronous fetch; repository provides both sync and async variations.
    _allProducts = ProductRepository.instance.fetchAll();
  }

  String _categoryOf(Product p) {
    final name = p.name.toLowerCase();
    if (p.discountedPrice != null || name.contains('best seller')) {
      return 'Popular';
    }
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

  // We delegate filtering/sorting to ShopSkeleton via an applyFilterSort callback.
  List<dynamic> _applyFilterSort(
      Iterable<dynamic> items, String filter, String sort) {
    final list = items.cast<Product>().toList();

    final filtered = filter == 'All'
        ? List<Product>.from(list)
        : list.where((p) => _categoryOf(p) == filter).toList();

    if (sort == 'Price: Low to High') {
      filtered.sort((a, b) => _priceOf(a).compareTo(_priceOf(b)));
    } else if (sort == 'Price: High to Low') {
      filtered.sort((a, b) => _priceOf(b).compareTo(_priceOf(a)));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    // Provide options and the apply function to ShopSkeleton
    const filterOptions = [
      DropdownMenuItem(value: 'All', child: Text('All')),
      DropdownMenuItem(value: 'Clothing', child: Text('Clothing')),
      DropdownMenuItem(value: 'Merchandise', child: Text('Merch')),
      DropdownMenuItem(value: 'Popular', child: Text('Popular')),
    ];

    const sortOptions = [
      DropdownMenuItem(value: 'None', child: Text('None')),
      DropdownMenuItem(value: 'Price: Low to High', child: Text('Low → High')),
      DropdownMenuItem(value: 'Price: High to Low', child: Text('High → Low')),
    ];

    return ShopSkeleton(
      title: 'Clothing',
      items: _allProducts,
      enableFilterSort: true,
      filterOptions: filterOptions,
      sortOptions: sortOptions,
      applyFilterSort: (items, filter, sort) =>
          _applyFilterSort(items, filter, sort),
    );
  }
}
