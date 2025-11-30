import 'package:flutter/material.dart';
import 'package:union_shop/widgets/base_scaffold.dart';
import 'package:union_shop/widgets/header.dart';
import 'package:union_shop/widgets/footer.dart';
import 'package:union_shop/repositories/product_repository.dart';
import 'package:union_shop/widgets/product_card.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void placeholderCallbackForButtons() {}

  @override
  Widget build(BuildContext context) {
    final all = ProductRepository.instance.fetchAll();
    final saleProducts = all.where((p) => p.discountedPrice != null).toList();

    const headerSection = Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sale Items',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Discounted products and special offers. Browse while stocks last!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );

    final productsGrid = Padding(
      padding: const EdgeInsets.all(24.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: MediaQuery.of(context).size.width > 800 ? 3 : 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: saleProducts.map((p) => ProductCard(product: p)).toList(),
      ),
    );

    return BaseScaffold(
      header: Header(
        onLogoTap: () => navigateToHome(context),
        onPlaceholderPressed: placeholderCallbackForButtons,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerSection,
          productsGrid,
        ],
      ),
      footer: const Footer(),
    );
  }
}
