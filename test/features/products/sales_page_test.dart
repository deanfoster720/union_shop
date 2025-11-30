import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/features/products/repositories/product_repository.dart';
import 'package:union_shop/features/products/views/sales_page.dart';

void main() {
  group('Sales Page', () {
    Future<void> pumpSalesPage(WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SalesScreen()));
      await tester.pumpAndSettle();
    }

    testWidgets('shows sale header and discounted products only', (tester) async {
      await pumpSalesPage(tester);

      expect(find.text('SALE ITEMS'), findsOneWidget);
      expect(find.text("Don’t miss out! Get yours before they’re all gone!"),
          findsOneWidget);

      final discounted =
          ProductRepository.instance.fetchAll().where((p) => p.discountedPrice != null);
      for (final product in discounted) {
        expect(find.text(product.name), findsWidgets);
        expect(find.text('£${product.discountedPrice!.toStringAsFixed(2)}'),
            findsWidgets);
      }

      final nonDiscounted =
          ProductRepository.instance.fetchAll().where((p) => p.discountedPrice == null);
      for (final product in nonDiscounted) {
        expect(find.text(product.name), findsNothing);
      }
    });

    testWidgets('applies price filter to reduce visible items', (tester) async {
      await pumpSalesPage(tester);

      await tester.tap(find.byType(DropdownButton<String>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Under £5').last);
      await tester.pumpAndSettle();

      expect(find.text('Limited Edition Essential Zip Hoodie'), findsNothing);
      expect(find.text('Essential T-shirt'), findsNothing);
    });
  });
}
