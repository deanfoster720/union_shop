import 'package:flutter/material.dart';
import 'package:union_shop/features/products/models/product.dart';
import 'package:union_shop/features/products/services/products_service.dart';

import 'shop_skeleton.dart';

class ShopPage extends StatefulWidget {
  ShopPage({Key? key, ProductsService? productsService})
      : _productsService = productsService ?? ProductsService(),
        super(key: key);

  final ProductsService _productsService;

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  late final Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = widget._productsService.loadProducts();
  }

  List<dynamic> _applyFilterSort(
    Iterable<dynamic> items,
    String filter,
    String sort,
  ) {
    return widget._productsService.filterAndSort(
      items.cast<Product>(),
      filter: filter,
      sort: sort,
    );
  }

  @override
  Widget build(BuildContext context) {
    const filterOptions = [
      DropdownMenuItem(value: 'All', child: Text('All')),
      DropdownMenuItem(value: 'Clothing', child: Text('Clothing')),
      DropdownMenuItem(value: 'Merchandise', child: Text('Merchandise')),
      DropdownMenuItem(value: 'Popular', child: Text('Popular')),
    ];

    const sortOptions = [
      DropdownMenuItem(value: 'None', child: Text('None')),
      DropdownMenuItem(value: 'Price: Low to High', child: Text('Low → High')),
      DropdownMenuItem(value: 'Price: High to Low', child: Text('High → Low')),
    ];

    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Failed to load products: ${snapshot.error}'),
          );
        }

        final products = snapshot.data ?? <Product>[];

        return ShopSkeleton(
          title: 'Shop',
          items: products,
          enableFilterSort: true,
          filterOptions: filterOptions,
          sortOptions: sortOptions,
          applyFilterSort: _applyFilterSort,
        );
      },
    );
  }
}
