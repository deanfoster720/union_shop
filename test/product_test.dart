import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/product_page.dart';
import 'package:union_shop/repositories/product_repository.dart';
import 'package:union_shop/models/product.dart';

void main() {
  group('Product Page Tests', () {
    Widget createTestWidget() {
      final Product sample = ProductRepository.instance.fetchAll().first;
      return MaterialApp(home: ProductPage(product: sample));
    }

    testWidgets('should display product page with basic elements', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that product UI elements are present
      final Product sample = ProductRepository.instance.fetchAll().first;
      expect(find.text(sample.name), findsOneWidget);
      expect(find.text(sample.displayPrice), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
    });

    testWidgets('should display student instruction text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // The product description should be visible
      final Product sample2 = ProductRepository.instance.fetchAll().first;
      expect(find.text(sample2.description), findsOneWidget);
    });

    testWidgets('should display header icons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that header icons are present
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('should display footer', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that footer is present (updated content)
      expect(find.text('Opening Hours:'), findsOneWidget);
      expect(find.text('Latest Offers:'), findsOneWidget);
    });
  });
}
