import 'package:flutter/material.dart';
import 'package:union_shop/views/shop_skeleton.dart';
import 'package:union_shop/repositories/product_repository.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  String _filter = 'All';
  String _sort = 'Default';

  List productsForDisplay(List all) {
    // Start with sale items only
    var list = all.where((p) => p.discountedPrice != null).toList();

    // Apply filter
    if (_filter == 'Under £5') {
      list = list.where((p) => p.discountedPrice! < 5.0).toList();
    } else if (_filter == '£5 - £20') {
      list = list
          .where((p) => p.discountedPrice! >= 5.0 && p.discountedPrice! <= 20.0)
          .toList();
    } else if (_filter == 'Over £20') {
      list = list.where((p) => p.discountedPrice! > 20.0).toList();
    }

    // Apply sort
    if (_sort == 'Price: Low → High') {
      list.sort((a, b) => a.discountedPrice!.compareTo(b.discountedPrice!));
    } else if (_sort == 'Price: High → Low') {
      list.sort((a, b) => b.discountedPrice!.compareTo(a.discountedPrice!));
    } else if (_sort == 'Name: A → Z') {
      list.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sort == 'Name: Z → A') {
      list.sort((a, b) => b.name.compareTo(a.name));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final all = ProductRepository.instance.fetchAll();
    final filtered = productsForDisplay(all);

    return ShopSkeleton(
      title: 'Sale Items',
      items: filtered,
    );
  }
}
