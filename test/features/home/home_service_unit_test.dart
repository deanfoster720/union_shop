import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/features/home/services/home_service.dart';
import 'package:union_shop/features/products/repositories/product_repository.dart';

void main() {
  test('HomeService returns the first six products as featured', () async {
    final repo = ProductRepository.instance;
    final service = HomeService(productRepository: repo);

    final featured = await service.fetchFeaturedProducts();

    expect(featured, hasLength(6));
    expect(featured.map((p) => p.id).toList(),
        equals(repo.fetchAll().take(6).map((p) => p.id).toList()));
  });
}
