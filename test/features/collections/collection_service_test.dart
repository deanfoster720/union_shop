import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/features/collections/services/collection_service.dart';
import 'package:union_shop/features/products/repositories/product_repository.dart';
import 'package:union_shop/features/collections/repositories/collection_repository.dart';

void main() {
  final productRepo = ProductRepository.instance;
  final collectionRepo = CollectionRepository.instance;
  final service = CollectionService(
    productRepository: productRepo,
    collectionRepository: collectionRepo,
  );

  group('CollectionService.loadProductsForCollection', () {
    test('returns matching products when collection id is provided', () async {
      final products = await service.loadProductsForCollection(
        'any-name',
        collectionId: 'black-friday-clothing',
      );

      expect(products, hasLength(4));
      expect(products.map((p) => p.id), everyElement(isIn(['5', '6', '7', '8'])));
    });

    test('matches collections by name if id is absent', () async {
      final products = await service.loadProductsForCollection('Essential Range');

      expect(products.map((p) => p.id).toList(), ['17', '18', '19', '20']);
    });

    test('falls back to all products when no collection is found', () async {
      final products = await service.loadProductsForCollection('non-existent');

      expect(products, hasLength(productRepo.fetchAll().length));
    });
  });
}
