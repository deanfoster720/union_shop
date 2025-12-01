import 'package:union_shop/features/products/models/product.dart';
import 'package:union_shop/features/products/repositories/product_repository.dart';

class HomeService {
  HomeService({ProductRepository? productRepository})
      : _productRepository = productRepository ?? ProductRepository.instance;

  final ProductRepository _productRepository;

  Future<List<Product>> fetchFeaturedProducts() async {
    final products = await _productRepository.fetchAllAsync();
    return products.take(6).toList();
  }
}
