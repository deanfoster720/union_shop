import 'package:union_shop/features/products/models/product.dart';
import 'package:union_shop/features/products/repositories/product_repository.dart';

class ProductsService {
  ProductsService({ProductRepository? repository})
      : _repository = repository ?? ProductRepository.instance;

  final ProductRepository _repository;

  Future<List<Product>> loadProducts() {
    return _repository.fetchAllAsync();
  }

  String categoryOf(Product product) {
    final name = product.name.toLowerCase();
    if (product.discountedPrice != null || name.contains('best seller')) {
      return 'Popular';
    }
    const clothingKeywords = [
      'hoodie',
      't-shirt',
      'tshirt',
      'tee',
      'sweatshirt',
      'jacket',
      'sports'
    ];
    for (final keyword in clothingKeywords) {
      if (name.contains(keyword)) return 'Clothing';
    }
    const merchKeywords = [
      'postcard',
      'magnet',
      'bookmark',
      'notebook',
      'mug',
      'sticker',
      'pack'
    ];
    for (final keyword in merchKeywords) {
      if (name.contains(keyword)) return 'Merchandise';
    }
    return 'Clothing';
  }

  List<Product> filterAndSort(
    Iterable<Product> products, {
    required String filter,
    required String sort,
  }) {
    final filtered = filter == 'All'
        ? List<Product>.from(products)
        : products.where((p) => categoryOf(p) == filter).toList();

    if (sort == 'Price: Low to High') {
      filtered.sort((a, b) => _priceOf(a).compareTo(_priceOf(b)));
    } else if (sort == 'Price: High to Low') {
      filtered.sort((a, b) => _priceOf(b).compareTo(_priceOf(a)));
    }

    return filtered;
  }

  double _priceOf(Product product) => product.discountedPrice ?? product.price;
}
