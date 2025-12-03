import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/features/cart/models/cart_item.dart';
import 'package:union_shop/features/cart/services/checkout_service.dart';
import 'package:union_shop/features/products/models/product.dart';

void main() {
  group('CheckoutService.placeOrder', () {
    test('succeeds when at least one item is present', () async {
      final items = [
        CartItem(
          product: const Product(
            id: 'p1',
            name: 'Test Product',
            price: 10,
            description: 'A product for testing.',
            categories: ['Test'],
          ),
          qty: 2,
          unitPrice: 10.0,
        ),
      ];

      final success = await CheckoutService.instance.placeOrder(items);

      expect(success, isTrue);
    });

    test('fails when attempting to place an empty order', () async {
      final success = await CheckoutService.instance.placeOrder(const []);

      expect(success, isFalse);
    });
  });
}
