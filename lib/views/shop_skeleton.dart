import 'package:flutter/material.dart';
import 'package:union_shop/widgets/base_scaffold.dart';
import 'package:union_shop/widgets/header.dart';
import 'package:union_shop/widgets/footer.dart';

/// A generic skeleton used as the base for shop category pages.
class ShopSkeleton extends StatelessWidget {
  final String title;
  final List<String> items;

  const ShopSkeleton({Key? key, required this.title, required this.items})
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
            const SizedBox(height: 48),
            Column(
              children: items
                  .map(
                    (name) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(name),
                    ),
                  )
                  .toList(),
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
