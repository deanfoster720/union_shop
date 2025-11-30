import 'package:flutter/material.dart';
import 'shop_skeleton.dart';

class ClothingPage extends StatelessWidget {
  const ClothingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clothingItems = [
      'T-Shirt',
      'Hoodie',
      'Sweatshirt',
      'Jacket',
      'Sports Top',
    ];

    return ShopSkeleton(title: 'Clothing', items: clothingItems);
  }
}
