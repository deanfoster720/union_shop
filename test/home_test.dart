import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';

void main() {
  group('Home Page Tests', () {
    testWidgets('should display home page with basic elements', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      // Check that basic UI elements are present
      expect(find.text('Essential Range - Over 20% OFF!'), findsOneWidget);
      expect(find.text('PRODUCTS SECTION'), findsOneWidget);
      expect(find.text('BROWSE PRODUCTS'), findsOneWidget);
    });

    testWidgets('should display product cards', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      // Check that product cards are displayed (using sample repository data)
      expect(find.text('Limited Edition Essential Zip Hoodie'), findsOneWidget);
      expect(find.text('Essential T-shirt'), findsOneWidget);
      expect(find.text('Signature Hoodie'), findsOneWidget);
      expect(find.text('Signature T-shirt'), findsOneWidget);

      // Check prices are displayed
      expect(find.text('£34.99'), findsOneWidget);
      expect(find.text('£8.99'), findsOneWidget);
      expect(find.text('£39.99'), findsOneWidget);
      expect(find.text('£14.99'), findsOneWidget);
    });

    testWidgets('should display header icons', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      // Check that header icons are present
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('should display footer', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();

      // Check that footer is present
      expect(find.text('Placeholder Footer'), findsOneWidget);
    });
  });
}
