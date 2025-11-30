import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/features/cart/services/cart_service.dart';
import 'package:union_shop/features/products/repositories/product_repository.dart';

void main() {
  final cart = CartService.instance;
  final products = ProductRepository.instance.fetchAll();

  setUp(() {
    cart.clear();
  });

  test('adds items and calculates totals', () {
    cart.addItem(products.first, 2);
    cart.addItem(products[1]);

    expect(cart.totalItems, 3);
    expect(cart.totalPrice, closeTo(34.99 * 2 + 8.99, 0.001));
    expect(cart.items.length, 2);
  });

  test('updates quantities and removes products', () {
    cart.addItem(products.first);
    cart.updateQty(products.first.id, 3);

    expect(cart.subtotalFor(products.first.id), closeTo(34.99 * 3, 0.001));

    cart.removeItem(products.first.id);
    expect(cart.totalItems, 0);
    expect(cart.totalPrice, 0);
  });

  test('ignores invalid quantity updates', () {
    cart.addItem(products.first);
    cart.updateQty(products.first.id, 0);

    expect(cart.totalItems, 1);
    expect(cart.totalPrice, closeTo(34.99, 0.001));
  });

  test('clears cart state', () {
    cart.addItem(products.first, 2);
    cart.clear();

    expect(cart.items, isEmpty);
    expect(cart.totalItems, 0);
    expect(cart.totalPrice, 0);
  });
}
