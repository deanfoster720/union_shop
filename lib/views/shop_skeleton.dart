import 'package:flutter/material.dart';
import 'package:union_shop/widgets/base_scaffold.dart';
import 'package:union_shop/widgets/header.dart';
import 'package:union_shop/widgets/footer.dart';

/// A generic skeleton used as the base for shop category pages.

class ShopSkeleton extends StatelessWidget {
  final String title;
  final Iterable<String> items;
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
                final itemList = items is List<String>
                    ? items as List<String>
                    : items.toList();
                return List.generate(itemList.length, (index) {
                  return _ProductCard(name: itemList[index]);
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

class _ProductCard extends StatelessWidget {
  final String name;

  const _ProductCard({Key? key, required this.name}) : super(key: key);

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
