import 'package:flutter/material.dart';
import 'package:union_shop/features/collections/services/collection_service.dart';
import 'package:union_shop/features/products/widgets/product_card.dart';
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

    return BaseScaffold(
      header: Header(
        onLogoTap: () => navigateToHome(context),
        onPlaceholderPressed: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collectionName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'A selection of items in this collection',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),

                // Dummy filter controls
                Row(
                  children: [
                    DropdownButton<String>(
                      value: 'Size',
                      items: const [
                        DropdownMenuItem(value: 'Size', child: Text('Size')),
                        DropdownMenuItem(value: 'S', child: Text('S')),
                        DropdownMenuItem(value: 'M', child: Text('M')),
                        DropdownMenuItem(value: 'L', child: Text('L')),
                      ],
                      onChanged: (_) {},
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: 'Sort',
                      items: const [
                        DropdownMenuItem(value: 'Sort', child: Text('Sort')),
                        DropdownMenuItem(
                            value: 'Newest', child: Text('Newest')),
                        DropdownMenuItem(
                            value: 'PriceLow', child: Text('Price: Low')),
                        DropdownMenuItem(
                            value: 'PriceHigh', child: Text('Price: High')),
                      ],
                      onChanged: (_) {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            FutureBuilder<List<Product>>(
              future: productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Failed to load products.'));
                }

                final products = snapshot.data ?? [];

                if (products.isEmpty) {
                  return const Center(
                    child:
                        Text('No products are available for this collection.'),
                  );
                }

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: MediaQuery.of(context).size.width > 800 ? 3 : 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: products
                      .map((p) => ProductCard(product: p))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
      footer: const Footer(),
    );
  }
}
