import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/features/cart/services/cart_service.dart';
import 'package:union_shop/features/products/models/product.dart';
import 'package:union_shop/features/products/views/product_page.dart';

void main() {
  const product = Product(
    id: 'p-w1',
    name: 'Widget Product',
    price: 5.0,
    description: 'desc',
  );

  setUp(() {
    CartService.instance.clear();
  });

  testWidgets('decrement button disabled at qty 1', (tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: ProductPage(product: product)));

    // find the remove IconButton
    final removeFinder = find.widgetWithIcon(IconButton, Icons.remove);
    expect(removeFinder, findsOneWidget);

    final removeButton = tester.widget<IconButton>(removeFinder);
    expect(removeButton.onPressed, isNull);
  });

  testWidgets('increment button disables when selected reaches remaining',
      (tester) async {
    // put 3 in cart so remaining = 2
    CartService.instance.addItem(product, 3);

    await tester
        .pumpWidget(const MaterialApp(home: ProductPage(product: product)));

    final addFinder = find.widgetWithIcon(IconButton, Icons.add);
    expect(addFinder, findsOneWidget);

    // initial _qty == 1, should be able to increment once to 2
    final addButtonBefore = tester.widget<IconButton>(addFinder);
    expect(addButtonBefore.onPressed, isNotNull);

    // call the onPressed directly to avoid hit-testing issues
    addButtonBefore.onPressed!();
    await tester.pumpAndSettle();

    // after one invocation, _qty should equal remaining (2), so add button should be disabled
    final addButtonAfter = tester.widget<IconButton>(addFinder);
    expect(addButtonAfter.onPressed, isNull);
  });
}
