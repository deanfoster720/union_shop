import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/features/collections/repositories/collection_repository.dart';

void main() {
  group('CollectionRepository', () {
    test('exposes the predefined collections list', () {
      final collections = CollectionRepository.instance.fetchAll();

      expect(collections, hasLength(5));
      expect(collections.first.id, 'autumn-favourites');
      expect(collections.last.productIds, containsAll(['17', '18', '19', '20']));
    });

    test('supports async fetch and fuzzy lookups', () async {
      final repo = CollectionRepository.instance;
      final collections = await repo.fetchAllAsync();

      expect(collections.map((c) => c.id), contains('elections-discounts'));
      expect(repo.findByIdOrName('Black Friday Clothing')?.id,
          'black-friday-clothing');
      expect(repo.findByIdOrName('unknown'), isNull);
    });
  });
}
