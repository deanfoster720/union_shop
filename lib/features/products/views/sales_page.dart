import 'package:flutter/material.dart';
import 'package:union_shop/features/products/repositories/product_repository.dart';

import 'shop_skeleton.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  // ShopSkeleton will manage selected filter/sort values; this function
  // applies the selected values to the provided items and returns the list
  // to display.
  List<dynamic> _applyFilterSort(
      Iterable<dynamic> items, String filter, String sort) {
    var list =
        items.cast<dynamic>().where((p) => p.discountedPrice != null).toList();

    // Apply filter
    if (filter == 'Under £5') {
      list = list.where((p) => p.discountedPrice! < 5.0).toList();
    } else if (filter == '£5 - £20') {
      list = list
          .where((p) => p.discountedPrice! >= 5.0 && p.discountedPrice! <= 20.0)
          .toList();
    } else if (filter == 'Over £20') {
      list = list.where((p) => p.discountedPrice! > 20.0).toList();
    }

    // Apply sort
    if (sort == 'Price: Low → High') {
      list.sort((a, b) => a.discountedPrice!.compareTo(b.discountedPrice!));
    } else if (sort == 'Price: High → Low') {
      list.sort((a, b) => b.discountedPrice!.compareTo(a.discountedPrice!));
    } else if (sort == 'Name: A → Z') {
      list.sort((a, b) => a.name.compareTo(b.name));
    } else if (sort == 'Name: Z → A') {
      list.sort((a, b) => b.name.compareTo(a.name));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final all = ProductRepository.instance.fetchAll();

    const filterOptions = [
      DropdownMenuItem(value: 'All', child: Text('All')),
      DropdownMenuItem(value: 'Under £5', child: Text('Under £5')),
      DropdownMenuItem(value: '£5 - £20', child: Text('£5 - £20')),
      DropdownMenuItem(value: 'Over £20', child: Text('Over £20')),
    ];

    const sortOptions = [
      DropdownMenuItem(value: 'Default', child: Text('Default')),
      DropdownMenuItem(
          value: 'Price: Low → High', child: Text('Price: Low → High')),
      DropdownMenuItem(
          value: 'Price: High → Low', child: Text('Price: High → Low')),
      DropdownMenuItem(value: 'Name: A → Z', child: Text('Name: A → Z')),
      DropdownMenuItem(value: 'Name: Z → A', child: Text('Name: Z → A')),
    ];

    return ShopSkeleton(
      title: 'Sale Items',
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Don’t miss out! Get yours before they’re all gone!"),
          SizedBox(height: 6),
          Text("All prices shown are inclusive of the discount"),
        ],
      ),
      items: all,
      enableFilterSort: true,
      filterOptions: filterOptions,
      sortOptions: sortOptions,
      applyFilterSort: (items, filter, sort) =>
          _applyFilterSort(items, filter, sort),
    );
  }
}
