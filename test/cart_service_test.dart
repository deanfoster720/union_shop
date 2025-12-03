import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:union_shop/features/cart/services/cart_service.dart';
import 'package:union_shop/features/products/models/product.dart';
import 'package:union_shop/features/products/repositories/product_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final repoProduct =
      ProductRepository.instance.fetchAll().firstWhere((p) => p.id == '1');
  const product = Product(
    id: 'p1',
    name: 'Test Product',
    price: 10.0,
    description: 'desc',
    categories: [],
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    CartService.instance.resetForTest();
  });

  test('ensureLoaded triggers load when using addItem', () async {
    final savedData = [
      {'productId': repoProduct.id, 'unitPrice': repoProduct.price, 'qty': 2},
    ];
    SharedPreferences.setMockInitialValues(
      {'union_shop_cart_v1': jsonEncode(savedData)},
    );
    CartService.instance.resetForTest();

    CartService.instance.addItem(repoProduct);

    expect(CartService.instance.qtyFor(repoProduct.id), 3);
    expect(CartService.instance.totalItems, 3);
  });

  test('initialize loads saved data safely', () async {
    final savedData = [
      {'productId': repoProduct.id, 'unitPrice': repoProduct.price, 'qty': 1},
      // product missing from repository but reconstructible from snapshot
      {
        'productId': 'missing',
        'unitPrice': 9.99,
        'qty': '3',
        'product': {
          'id': 'missing',
          'name': 'Rebuilt Product',
          'price': 9.99,
          'description': 'restored',
          'categories': ['Recovered'],
        },
      },
      // malformed entries should be ignored
      {'productId': 'bad', 'qty': 2},
      'invalid',
      10,
    ];

    SharedPreferences.setMockInitialValues(
      {'union_shop_cart_v1': jsonEncode(savedData)},
    );
    CartService.instance.resetForTest();

    await CartService.instance.initialize();

    expect(CartService.instance.qtyFor(repoProduct.id), 1);
    expect(CartService.instance.qtyFor('missing'), 3);
    expect(CartService.instance.totalItems, 4);
  });

  test('save and load persistence uses shared preferences', () async {
    CartService.instance.addItem(product, 2);
    await Future<void>.delayed(Duration.zero);

    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('union_shop_cart_v1');
    expect(stored, isNotNull);

    final parsed = jsonDecode(stored!) as List;
    expect(parsed.length, 1);
    expect(parsed.first['productId'], product.id);
    expect(parsed.first['qty'], 2);
  });

  test('addItem clamps to maxPerItem', () {
    CartService.instance.addItem(product, 3);
    expect(CartService.instance.qtyFor(product.id), 3);

    // add more than remaining -> should clamp to maxPerItem (5)
    CartService.instance.addItem(product, 4);
    expect(CartService.instance.qtyFor(product.id), CartService.maxPerItem);
  });

  test('addItem from zero with large qty clamps to max', () {
    CartService.instance.addItem(product, 10);
    expect(CartService.instance.qtyFor(product.id), CartService.maxPerItem);
  });

  test('updateQty clamps to maxPerItem', () {
    CartService.instance.addItem(product, 1);
    expect(CartService.instance.qtyFor(product.id), 1);

    CartService.instance.updateQty(product.id, 10);
    expect(CartService.instance.qtyFor(product.id), CartService.maxPerItem);
  });

  test('removeItem deletes and persists change', () async {
    CartService.instance.addItem(product, 1);
    CartService.instance.addItem(repoProduct, 1);

    CartService.instance.removeItem(product.id);
    expect(CartService.instance.qtyFor(product.id), 0);
    expect(CartService.instance.totalItems, 1);

    await Future<void>.delayed(Duration.zero);
    final prefs = await SharedPreferences.getInstance();
    final stored = jsonDecode(prefs.getString('union_shop_cart_v1')!);
    expect((stored as List).every((e) => e['productId'] != product.id), isTrue);
  });

  test('clear empties cart and persistence', () async {
    CartService.instance.addItem(product, 2);
    CartService.instance.addItem(repoProduct, 1);

    CartService.instance.clear();
    expect(CartService.instance.totalItems, 0);

    await Future<void>.delayed(Duration.zero);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('union_shop_cart_v1'), jsonEncode([]));
  });

  test('subtotalFor returns correct subtotal or zero', () {
    CartService.instance.addItem(product, 2);
    expect(CartService.instance.subtotalFor(product.id), 20.0);
    expect(CartService.instance.subtotalFor('missing'), 0.0);
  });

  test('totalPrice sums all items', () {
    CartService.instance.addItem(product, 2);
    CartService.instance.addItem(repoProduct, 1);

    final expected = (product.price * 2) + repoProduct.discountedPrice!;
    expect(CartService.instance.totalPrice, expected);
  });
}
