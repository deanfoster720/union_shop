import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/features/products/repositories/product_repository.dart';

void main() {
  group('ProductRepository.fetchAll', () {
    test('returns the full static catalogue', () {
      final products = ProductRepository.instance.fetchAll();

      expect(products, hasLength(20));
      expect(products.first.id, '1');
      expect(products.first.name, 'Limited Edition Essential Zip Hoodie');
      expect(products.last.id, '20');
    });

    test('provides the same items asynchronously', () async {
      final products = await ProductRepository.instance.fetchAllAsync();

      expect(products, hasLength(20));
      expect(products.map((p) => p.id).toSet().length, 20);
    });
  });
}
