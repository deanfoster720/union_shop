import 'package:flutter/foundation.dart';
import 'package:union_shop/features/products/models/product.dart';

import '../models/cart_item.dart';

class CartService extends ChangeNotifier {
  CartService._();
  static final CartService instance = CartService._();

  /// Maximum quantity allowed per individual product
  static const int maxPerItem = 5;

  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  int get totalItems => _items.values.fold(0, (sum, it) => sum + it.qty);

  double get totalPrice =>
      _items.values.fold(0.0, (sum, it) => sum + it.subtotal);

  void addItem(Product product, [int qty = 1]) {
    final id = product.id;
    final unit = product.discountedPrice ?? product.price;
    final existing = _items[id]?.qty ?? 0;
    final allowed = maxPerItem - existing;
    if (allowed <= 0) return; // already at or above max
    final toAdd = qty > allowed ? allowed : qty;
    if (_items.containsKey(id)) {
      _items[id]!.qty += toAdd;
    } else {
      _items[id] = CartItem(product: product, unitPrice: unit, qty: toAdd);
    }
    notifyListeners();
  }

  void updateQty(String productId, int qty) {
    if (qty < 1) return;
    final item = _items[productId];
    if (item != null) {
      final clamped = qty > maxPerItem ? maxPerItem : qty;
      item.qty = clamped;
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

  /// Return current quantity in cart for a product id
  int qtyFor(String productId) => _items[productId]?.qty ?? 0;
}
