import 'package:flutter/material.dart';
import 'package:union_shop/widgets/base_scaffold.dart';
import 'package:union_shop/widgets/header.dart';
import 'package:union_shop/widgets/footer.dart';
// Collections page does not use products; show collections only

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void placeholderCallbackForButtons() {
    // Placeholder for header buttons
  }

  @override
  Widget build(BuildContext context) {
    final collectionNames = [
      'Autumn Favourites',
      'Black Friday Clothing',
      'Clothing - Original',
      'Elections Discounts',
      'Essential Range',
    ];

    final productsSection = Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            const Text(
              'COLLECTIONS',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 48),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 24,
              mainAxisSpacing: 48,
              // Render tiles for the provided collection names only
              children: List.generate(collectionNames.length, (index) {
                return CollectionCard(
                    name: collectionNames[index], imageUrl: null);
              }),
            ),
          ],
        ),
      ),
    );

    return BaseScaffold(
      header: Header(
        onLogoTap: () => navigateToHome(context),
        onPlaceholderPressed: placeholderCallbackForButtons,
      ),
      body: Column(
        children: [
          productsSection,
        ],
      ),
      footer: const Footer(),
    );
  }
}

class CollectionCard extends StatelessWidget {
  final String name;
  final String? imageUrl;

  const CollectionCard({
    super.key,
    required this.name,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported,
                                  color: Colors.grey),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              color: Colors.grey),
                        ),
                      ),
              ),
              Positioned.fill(
                // Dark overlay so white text is readable on top of image
                child: Container(color: const Color.fromRGBO(0, 0, 0, 0.7)),
              ),
              Center(
                child: Text(
                  name,
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
      ],
    );
  }
}
