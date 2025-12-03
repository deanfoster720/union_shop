import 'package:flutter/material.dart';
import 'package:union_shop/core/widgets/base_scaffold.dart';
import 'package:union_shop/core/widgets/footer.dart';
import 'package:union_shop/core/widgets/header.dart';
import 'package:union_shop/features/collections/services/collection_service.dart';
import 'package:union_shop/features/products/repositories/product_repository.dart';
import '../views/collection_detail_page.dart';
import '../models/collection.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final collectionService =
        CollectionService(productRepository: ProductRepository.instance);
    final collectionsFuture = collectionService.getCollections();

    void navigateToHome() {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }

    return BaseScaffold(
      header: Header(onLogoTap: navigateToHome, onPlaceholderPressed: () {}),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Collections',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Browse curated collections of items',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 24),
            FutureBuilder<List<Collection>>(
              future: collectionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Failed to load collections.'));
                }

                final collections = snapshot.data ?? [];

                if (collections.isEmpty) {
                  return const Center(child: Text('No collections available.'));
                }

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 800 ? 3 : 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: collections.map((c) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CollectionDetailPage(
                              collectionName: c.name,
                              collectionService: collectionService,
                            ),
                          ),
                        );
                      },
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: c.imageUrl != null
                                  ? Image.asset(
                                      c.imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          Container(color: Colors.grey[200]),
                                    )
                                  : Container(color: Colors.grey[200]),
                            ),
                            Positioned.fill(
                              child: Container(
                                  color: const Color.fromRGBO(0, 0, 0, 0.35)),
                            ),
                            Center(
                              child: Text(
                                c.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
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
