import 'package:flutter/material.dart';
import 'package:union_shop/features/products/repositories/product_repository.dart';
import 'package:union_shop/features/products/widgets/product_card.dart';
import 'package:union_shop/core/widgets/base_scaffold.dart';
import 'package:union_shop/core/widgets/footer.dart';
import 'package:union_shop/core/widgets/header.dart';

class CollectionDetailPage extends StatelessWidget {
  final String collectionName;

  const CollectionDetailPage({super.key, required this.collectionName});

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // For this basic implementation we'll simply show all products
    // and treat this page as the detail view for the selected collection.
    // In a fuller implementation you might filter by collection membership.
    final products = ProductRepository.instance.fetchAll();

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

            // Product grid
            Expanded(
              child: GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 800 ? 3 : 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: products.map((p) => ProductCard(product: p)).toList(),
              ),
            ),
          ],
        ),
      ),
      footer: const Footer(),
    );
  }
}
