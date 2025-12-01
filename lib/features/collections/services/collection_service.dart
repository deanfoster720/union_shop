import 'package:union_shop/features/products/models/product.dart';
import 'package:union_shop/features/products/repositories/product_repository.dart';
import '../repositories/collection_repository.dart';
import '../models/collection.dart';

class CollectionService {
  CollectionService({
    required this.productRepository,
    CollectionRepository? collectionRepository,
  }) : collectionRepository =
            collectionRepository ?? CollectionRepository.instance;

  final ProductRepository productRepository;
  final CollectionRepository collectionRepository;

  Future<List<Collection>> getCollections() =>
      collectionRepository.fetchAllAsync();

  Future<List<Product>> loadProductsForCollection(
    String collectionName, {
    String? collectionId,
  }) async {
    final products = await productRepository.fetchAllAsync();

    final collections = await collectionRepository.fetchAllAsync();

    Collection? coll;
    if (collectionId != null) {
      for (final c in collections) {
        if (c.id == collectionId) {
          coll = c;
          break;
        }
      }
    }

    if (coll == null) {
      // try to match by name or normalized key
      final key = _normalizeCollectionKey(collectionName);
      for (final c in collections) {
        if (c.id == key ||
            c.name.toLowerCase() == collectionName.toLowerCase()) {
          coll = c;
          break;
        }
      }
    }

    final filteredIds = coll?.productIds;

    if (filteredIds == null) {
      return products;
    }

    final idSet = filteredIds.toSet();
    return products.where((product) => idSet.contains(product.id)).toList();
  }

  String _normalizeCollectionKey(String value) {
    final normalized =
        value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
    final collapsed = normalized.replaceAll(RegExp(r'-+'), '-');
    return collapsed.replaceAll(RegExp(r'^-|-$'), '');
  }
}
