import 'package:flutter/material.dart';
import 'package:union_shop/features/products/models/product.dart';
import 'package:union_shop/features/products/services/products_service.dart';

import 'shop_skeleton.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final ProductsService _productsService = ProductsService();
  late Future<List<Product>> _discountedProducts;

  @override
  void initState() {
    super.initState();
    _discountedProducts = _productsService.loadDiscountedProducts();
  }

  List<Product> _applyFilterSort(
      Iterable<Product> items, String filter, String sort) {
    return _productsService.filterDiscountedProducts(
      items,
      filter: filter,
      sort: sort,
    );
  }

  Widget _buildShop(List<Product> products) {
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
      subtitle: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Don’t miss out! Get yours before they’re all gone!"),
          SizedBox(height: 6),
          Text("All prices shown are inclusive of the discount"),
        ],
      ),
      items: products,
      enableFilterSort: true,
      filterOptions: filterOptions,
      sortOptions: sortOptions,
      applyFilterSort: (items, filter, sort) =>
          _applyFilterSort(items.cast<Product>(), filter, sort),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _discountedProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Failed to load sale items'));
        }

        final products = snapshot.data ?? <Product>[];
        return _buildShop(products);
      },
    );
  }
}
