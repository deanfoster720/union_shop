import 'package:flutter/material.dart';
import 'package:union_shop/features/collections/services/collection_service.dart';
import 'package:union_shop/features/products/views/shop_skeleton.dart';
import 'package:union_shop/features/products/services/products_service.dart';
import 'package:union_shop/core/widgets/base_scaffold.dart';
import 'package:union_shop/core/widgets/footer.dart';
import 'package:union_shop/core/widgets/header.dart';
import 'package:union_shop/features/products/models/product.dart';
import 'package:union_shop/features/products/repositories/product_repository.dart';

class CollectionDetailPage extends StatelessWidget {
  final String collectionName;
  final CollectionService collectionService;

  CollectionDetailPage({
    super.key,
    required this.collectionName,
    CollectionService? collectionService,
  }) : collectionService = collectionService ??
            CollectionService(productRepository: ProductRepository.instance);

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final productsFuture =
        collectionService.loadProductsForCollection(collectionName);

    return FutureBuilder<List<Product>>(
      future: productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return BaseScaffold(
            header: Header(
              onLogoTap: () => navigateToHome(context),
              onPlaceholderPressed: () {},
            ),
            body: const Center(child: CircularProgressIndicator()),
            footer: const Footer(),
          );
        }

        if (snapshot.hasError) {
          return BaseScaffold(
            header: Header(
              onLogoTap: () => navigateToHome(context),
              onPlaceholderPressed: () {},
            ),
            body: const Center(child: Text('Failed to load products.')),
            footer: const Footer(),
          );
        }

        final products = snapshot.data ?? [];

        if (products.isEmpty) {
          return BaseScaffold(
            header: Header(
              onLogoTap: () => navigateToHome(context),
              onPlaceholderPressed: () {},
            ),
            body: const Center(
                child: Text('No products are available for this collection.')),
            footer: const Footer(),
          );
        }

        // Build filter options from product categories to match ProductsService
        final categorySet = <String>{};
        for (final p in products) {
          categorySet.addAll(p.categories);
        }

        final filterOptions = <DropdownMenuItem<String>>[
          const DropdownMenuItem(value: 'All', child: Text('All')),
          ...categorySet.map((c) => DropdownMenuItem(value: c, child: Text(c)))
        ];

        final sortOptions = const [
          DropdownMenuItem(value: 'None', child: Text('None')),
          DropdownMenuItem(
              value: 'Price: Low to High', child: Text('Price: Low → High')),
          DropdownMenuItem(
              value: 'Price: High to Low', child: Text('Price: High → Low')),
        ];

        final productsService = ProductsService();

        return ShopSkeleton(
          title: collectionName,
          items: products,
          enableFilterSort: true,
          filterOptions: filterOptions,
          sortOptions: sortOptions,
          applyFilterSort: (items, filter, sort) {
            return productsService.filterAndSort(
              items.whereType<Product>(),
              filter: filter,
              sort: sort,
            );
          },
        );
      },
    );
  }
}
