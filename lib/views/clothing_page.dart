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

  @override
  Widget build(BuildContext context) {
    return ShopSkeleton(
      title: 'Clothing',
      items: _allProducts,
    );
  }
}
