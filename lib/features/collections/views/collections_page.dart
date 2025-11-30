import 'package:flutter/material.dart';
import 'package:union_shop/features/products/views/shop_skeleton.dart';

// Collections page reuses the ShopSkeleton so content and layout remain consistent.
class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final collectionNames = [
      'Autumn Favourites',
      'Black Friday Clothing',
      'Clothing - Original',
      'Elections Discounts',
      'Essential Range',
    ];

    return ShopSkeleton(title: 'Collections', items: collectionNames);
  }
}
