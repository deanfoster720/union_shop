import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/features/products/models/product.dart';
import 'package:union_shop/features/products/repositories/product_repository.dart';
import 'package:union_shop/features/products/views/product_page.dart';

void main() {
  group('Product Page', () {
    Widget createTestWidget() {
      final Product sample = ProductRepository.instance.fetchAll().first;
      return MaterialApp(home: ProductPage(product: sample));
    }

    testWidgets('shows product details and price', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final Product sample = ProductRepository.instance.fetchAll().first;
      expect(find.text(sample.name), findsOneWidget);
      expect(find.text(sample.displayPrice), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text(sample.description), findsOneWidget);
    });

    testWidgets('renders header icons and footer', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.text('Opening Hours:'), findsOneWidget);
      expect(find.text('Latest Offers:'), findsOneWidget);
    });

    testWidgets('adds items to cart with custom quantities', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('2'), findsOneWidget);

      await tester.tap(find.text('Add to cart'));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
