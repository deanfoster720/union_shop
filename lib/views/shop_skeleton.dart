import 'package:flutter/material.dart';
import 'package:union_shop/widgets/base_scaffold.dart';
import 'package:union_shop/widgets/header.dart';
import 'package:union_shop/widgets/footer.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/views/product_page.dart';

/// A generic skeleton used as the base for shop category pages.

class ShopSkeleton extends StatelessWidget {
  final String title;
  // Accept either list of names (String) or list of Product objects.
  final Iterable<dynamic> items;
  final Widget? filterWidget;

  const ShopSkeleton(
      {Key? key, required this.title, required this.items, this.filterWidget})
      : super(key: key);

  void _navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void _placeholder() {}

  @override
  Widget build(BuildContext context) {
    final section = Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            // Optional filter widget (e.g. dropdown) placed under title
            if (filterWidget != null) ...[
              filterWidget!,
              const SizedBox(height: 24),
            ] else ...[
              const SizedBox(height: 36),
            ],
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 24,
              mainAxisSpacing: 48,
              children: () {
                final itemList = items.toList();
                return List.generate(itemList.length, (index) {
                  final item = itemList[index];
                  if (item is Product) {
                    return _GridProductCard(product: item);
                  }
                  return _TextCard(name: item?.toString() ?? '');
                });
              }(),
            ),
          ],
        ),
      ),
    );

    return BaseScaffold(
      header: Header(
        onLogoTap: () => _navigateToHome(context),
        onPlaceholderPressed: _placeholder,
      ),
      body: Column(children: [section]),
      footer: const Footer(),
    );
  }
}

class _TextCard extends StatelessWidget {
  final String name;

  const _TextCard({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.grey[200],
            ),
          ),
          Positioned.fill(
            child: Container(color: const Color.fromRGBO(0, 0, 0, 0.35)),
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
    );
  }
}

class _GridProductCard extends StatelessWidget {
  final Product product;

  const _GridProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductPage(product: product)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: product.imageUrl != null
                ? Image.network(
                    product.imageUrl!,
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
                      child:
                          Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                product.name,
                style: const TextStyle(fontSize: 14, color: Colors.black),
                maxLines: 2,
              ),
              const SizedBox(height: 6),
              product.discountedPrice != null
                  ? Row(
                      children: [
                        Text(
                          '£${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '£${product.discountedPrice!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      product.displayPrice,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
