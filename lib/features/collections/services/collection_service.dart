import 'package:union_shop/features/products/models/product.dart';
import 'package:union_shop/features/products/repositories/product_repository.dart';

class CollectionService {
  CollectionService({required this.productRepository});

  final ProductRepository productRepository;

  Future<List<Product>> loadProductsForCollection(
    String collectionName, {
    String? collectionId,
  }) async {
    final products = await productRepository.fetchAllAsync();

    final filteredIds =
        _collectionProductIds[collectionId ?? _normalizeCollectionKey(collectionName)];

    if (filteredIds == null) {
      return products;
    }

    final idSet = filteredIds.toSet();
    return products.where((product) => idSet.contains(product.id)).toList();
  }

  String _normalizeCollectionKey(String value) {
    final normalized = value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
    final collapsed = normalized.replaceAll(RegExp(r'-+'), '-');
    return collapsed.replaceAll(RegExp(r'^-|-$'), '');
  }

  static const Map<String, List<String>> _collectionProductIds = {
    'autumn-favourites': ['1', '3', '8'],
    'black-friday-clothing': ['1', '2', '3', '4'],
    'clothing-original': ['3', '4'],
    'elections-discounts': ['2', '5', '6'],
    'essential-range': ['2', '5', '7', '8'],
  };
}
