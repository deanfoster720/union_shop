import 'package:union_shop/features/products/models/product.dart';
import 'package:union_shop/features/products/repositories/product_repository.dart';

class ProductsService {
  ProductsService({ProductRepository? repository})
      : _repository = repository ?? ProductRepository.instance;

  final ProductRepository _repository;

  Future<List<Product>> loadProducts() {
    return _repository.fetchAllAsync();
  }

  Future<List<Product>> loadDiscountedProducts({
    String filter = 'All',
    String sort = 'Default',
  }) async {
    final all = await _repository.fetchAllAsync();
    final discounted = all.where((p) => p.discountedPrice != null).toList();
    return filterDiscountedProducts(discounted, filter: filter, sort: sort);
  }

  List<Product> filterAndSort(
    Iterable<Product> products, {
    required String filter,
    required String sort,
  }) {
    final filtered = filter == 'All'
        ? List<Product>.from(products)
        : products.where((p) => p.categories.contains(filter)).toList();

    if (sort == 'Price: Low to High') {
      filtered.sort((a, b) => _priceOf(a).compareTo(_priceOf(b)));
    } else if (sort == 'Price: High to Low') {
      filtered.sort((a, b) => _priceOf(b).compareTo(_priceOf(a)));
    }

    return filtered;
  }

  List<Product> filterDiscountedProducts(
    Iterable<Product> products, {
    required String filter,
    required String sort,
  }) {
    var list =
        products.where((p) => p.discountedPrice != null).map((p) => p).toList();

    if (filter == 'Under £5') {
      list = list.where((p) => p.discountedPrice! < 5.0).toList();
    } else if (filter == '£5 - £20') {
      list = list
          .where((p) => p.discountedPrice! >= 5.0 && p.discountedPrice! <= 20.0)
          .toList();
    } else if (filter == 'Over £20') {
      list = list.where((p) => p.discountedPrice! > 20.0).toList();
    }

    if (sort == 'Price: Low → High') {
      list.sort((a, b) => a.discountedPrice!.compareTo(b.discountedPrice!));
    } else if (sort == 'Price: High → Low') {
      list.sort((a, b) => b.discountedPrice!.compareTo(a.discountedPrice!));
    } else if (sort == 'Name: A → Z') {
      list.sort((a, b) => a.name.compareTo(b.name));
    } else if (sort == 'Name: Z → A') {
      list.sort((a, b) => b.name.compareTo(a.name));
    }

    return list;
  }

  double _priceOf(Product product) => product.discountedPrice ?? product.price;
}
