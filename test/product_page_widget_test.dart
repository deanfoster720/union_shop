import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:union_shop/features/cart/services/cart_service.dart';
import 'package:union_shop/features/products/models/product.dart';
import 'package:union_shop/features/products/views/product_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const product = Product(
    id: 'p-w1',
    name: 'Widget Product',
    price: 5.0,
    description: 'desc',
    categories: [],
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    CartService.instance.resetForTest();
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

  testWidgets('addToCart clamps to remaining and shows snackbar',
      (tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: ProductPage(product: product)));

    await tester.tap(find.widgetWithIcon(IconButton, Icons.add));
    await tester.pumpAndSettle();

    CartService.instance.addItem(product, 4);

    await tester.tap(find.text('Add to cart'));
    await tester.pump();

    expect(CartService.instance.qtyFor(product.id), CartService.maxPerItem);
    expect(find.text('Widget Product added to cart (1)'), findsOneWidget);
  });

  testWidgets('addToCart shows max snackbar when at limit', (tester) async {
    CartService.instance.addItem(product, CartService.maxPerItem);

    await tester
        .pumpWidget(const MaterialApp(home: ProductPage(product: product)));

    await tester.tap(find.text('Add to cart'));
    await tester.pump();

    expect(CartService.instance.qtyFor(product.id), CartService.maxPerItem);
    expect(
      find.text(
        'You already have the maximum (${CartService.maxPerItem}) of ${product.name} in your cart.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('addToCart updates cart and shows confirmation snackbar',
      (tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: ProductPage(product: product)));

    await tester.tap(find.widgetWithIcon(IconButton, Icons.add));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add to cart'));
    await tester.pump();

    expect(CartService.instance.qtyFor(product.id), 2);
    expect(find.text('Widget Product added to cart (2)'), findsOneWidget);
  });

  testWidgets('tapping header logo navigates back to home', (tester) async {
    await tester.pumpWidget(MaterialApp(
      initialRoute: '/product',
      routes: {
        '/': (_) => const Placeholder(key: ValueKey('home')),
        '/product': (_) => const ProductPage(product: product),
      },
    ));

    final logoFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is NetworkImage &&
          (widget.image as NetworkImage).url.contains('upsu_300x300'),
    );

    expect(logoFinder, findsOneWidget);

    await tester.tap(logoFinder);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('home')), findsOneWidget);
  });
}
