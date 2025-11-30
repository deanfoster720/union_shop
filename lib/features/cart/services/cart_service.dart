import 'package:flutter/foundation.dart';
import 'package:union_shop/features/products/models/product.dart';

import '../models/cart_item.dart';

class CartService extends ChangeNotifier {
  CartService._();
  static final CartService instance = CartService._();

  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  int get totalItems => _items.values.fold(0, (sum, it) => sum + it.qty);

  double get totalPrice =>
      _items.values.fold(0.0, (sum, it) => sum + it.subtotal);

  void addItem(Product product, [int qty = 1]) {
    final id = product.id;
    final unit = product.discountedPrice ?? product.price;
    if (_items.containsKey(id)) {
      _items[id]!.qty += qty;
    } else {
      _items[id] = CartItem(product: product, unitPrice: unit, qty: qty);
    }
    notifyListeners();
  }

  void updateQty(String productId, int qty) {
    if (qty < 1) return;
    final item = _items[productId];
    if (item != null) {
      item.qty = qty;
      notifyListeners();
    }
  }

  void removeItem(String productId) {
    if (_items.containsKey(productId)) {
      _items.remove(productId);
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// Return subtotal for a product id, or 0.0 if not present
  double subtotalFor(String productId) {
    final item = _items[productId];
    return item?.subtotal ?? 0.0;
  }
}
