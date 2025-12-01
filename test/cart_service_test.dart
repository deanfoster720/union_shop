import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/features/cart/services/cart_service.dart';
import 'package:union_shop/features/products/models/product.dart';

void main() {
  const product = Product(
    id: 'p1',
    name: 'Test Product',
    price: 10.0,
    description: 'desc',
    categories: [],
  );

  setUp(() {
    CartService.instance.clear();
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
}
