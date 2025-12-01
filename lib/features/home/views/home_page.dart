import 'package:flutter/material.dart';
import 'package:union_shop/core/widgets/base_scaffold.dart';
import 'package:union_shop/core/widgets/footer.dart';
import 'package:union_shop/core/widgets/header.dart';
import 'package:union_shop/features/home/services/home_service.dart';
import 'package:union_shop/features/products/models/product.dart';
import 'package:union_shop/features/products/widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, HomeService? homeService})
      : _homeService = homeService ?? HomeService();

  final HomeService _homeService;

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void navigateToProduct(BuildContext context) {
    Navigator.pushNamed(context, '/product');
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  @override
  Widget build(BuildContext context) {
    final heroSection = LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final bool isCompact = screenWidth < 600;

        final double height = isCompact ? 320 : 420;
        final double titleSize = isCompact ? 26 : 32;
        final double bodySize = isCompact ? 18 : 20;
        final EdgeInsets contentPadding = EdgeInsets.symmetric(
          horizontal: isCompact ? 16 : 24,
          vertical: isCompact ? 24 : 40,
        );

        return SizedBox(
          width: double.infinity,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
              // Content overlay
              Padding(
                padding: contentPadding,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Essential Range - Over 20% OFF!',
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isCompact ? 12 : 16),
                        Text(
                          "Over 20% off of our Essential Range. Come and grab yours while stock lasts!",
                          style: TextStyle(
                            fontSize: bodySize,
                            color: Colors.white,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isCompact ? 20 : 32),
                        ElevatedButton(
                          onPressed: null,
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(
                                horizontal: isCompact ? 20 : 24,
                                vertical: isCompact ? 12 : 14,
                              ),
                            ),
                          ),
                          child: const Text('BROWSE PRODUCTS'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    final productsSection = Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            const Text(
              'PRODUCTS SECTION',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 48),
            FutureBuilder<List<Product>>(
              future: _homeService.fetchFeaturedProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Text('Failed to load products');
                }

                final products = snapshot.data ?? [];

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final bool isWide = constraints.maxWidth > 600;
                    final double childAspectRatio = isWide ? 1.3 : 1.0;
                    final int crossAxisCount = isWide ? 2 : 1;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 48,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) =>
                          ProductCard(product: products[index]),
                    );
                  },
                );
              },
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
          heroSection,
          productsSection,
        ],
      ),
      footer: const Footer(),
    );
  }
}
