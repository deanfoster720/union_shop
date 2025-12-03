import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:union_shop/features/products/models/product.dart';
import 'package:union_shop/features/products/repositories/product_repository.dart';

import '../models/cart_item.dart';

class CartService extends ChangeNotifier {
  CartService._();
  static final CartService instance = CartService._();

  static const String _prefsKey = 'union_shop_cart_v1';

  /// Maximum quantity allowed per individual product
  static const int maxPerItem = 5;

  final Map<String, CartItem> _items = {};

  bool _loaded = false;

  @visibleForTesting
  void resetForTest() {
    _items.clear();
    _loaded = false;
  }

  /// Trigger async load on creation
  void _ensureLoaded() {
    if (_loaded) return;
    _loaded = true;
    _loadFromPrefs();
  }

  /// Public initializer to allow callers (e.g. in `main`) to wait
  /// for the cart to be loaded before the app continues.
  Future<void> initialize() async {
    if (_loaded) return;
    _loaded = true;
    await _loadFromPrefs();
  }

  List<CartItem> get items => _items.values.toList();

  int get totalItems => _items.values.fold(0, (sum, it) => sum + it.qty);

  double get totalPrice =>
      _items.values.fold(0.0, (sum, it) => sum + it.subtotal);

  void addItem(Product product, [int qty = 1]) {
    _ensureLoaded();
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
    _saveToPrefs();
  }

  void updateQty(String productId, int qty) {
    _ensureLoaded();
    if (qty < 1) return;
    final item = _items[productId];
    if (item != null) {
      final clamped = qty > maxPerItem ? maxPerItem : qty;
      item.qty = clamped;
      notifyListeners();
      _saveToPrefs();
    }
  }

  void removeItem(String productId) {
    if (_items.containsKey(productId)) {
      _items.remove(productId);
      notifyListeners();
      _saveToPrefs();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
    _saveToPrefs();
  }

  /// Return subtotal for a product id, or 0.0 if not present
  double subtotalFor(String productId) {
    final item = _items[productId];
    return item?.subtotal ?? 0.0;
  }

  /// Return current quantity in cart for a product id
  int qtyFor(String productId) => _items[productId]?.qty ?? 0;

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _items.values.map((it) => it.toJson()).toList();
      final jsonStr = jsonEncode(list);
      await prefs.setString(_prefsKey, jsonStr);
    } catch (e) {
      // ignore persistence errors - preserve in-memory behaviour
    }
  }

  /// Public save wrapper
  Future<void> save() async => _saveToPrefs();

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_prefsKey);
      if (jsonStr == null || jsonStr.isEmpty) return;

      final dynamic parsed = jsonDecode(jsonStr);
      if (parsed is! List) return;

      // Build a map of products by id for quick lookup
      final products = ProductRepository.instance.fetchAll();
      final Map<String, Product> productMap = {for (var p in products) p.id: p};

      for (final item in parsed) {
        if (item is Map<String, dynamic>) {
          final pid = item['productId']?.toString();
          final unit = (item['unitPrice'] is num)
              ? (item['unitPrice'] as num).toDouble()
              : null;
          final qty = (item['qty'] is int)
              ? item['qty'] as int
              : (int.tryParse(item['qty']?.toString() ?? '') ?? 1);
          if (pid == null || unit == null) continue;

          Product? product = productMap[pid];

          // If product not in repository, try to reconstruct from snapshot
          if (product == null && item.containsKey('product')) {
            try {
              final p = item['product'];
              final discounted = p['discountedPrice'] is num
                  ? (p['discountedPrice'] as num).toDouble()
                  : null;
              final categories = (p['categories'] as List?)
                      ?.map((e) => e.toString())
                      .toList() ??
                  <String>[];
              final collectionIds = (p['collectionIds'] as List?)
                      ?.map((e) => e.toString())
                      .toList() ??
                  <String>[];

              product = Product(
                id: p['id']?.toString() ?? pid,
                name: p['name']?.toString() ?? 'Unknown',
                price:
                    (p['price'] is num) ? (p['price'] as num).toDouble() : 0.0,
                discountedPrice: discounted,
                description: p['description']?.toString() ?? '',
                imageUrl: p['imageUrl']?.toString(),
                categories: categories,
                collectionIds: collectionIds,
              );
            } catch (_) {
              product = null;
            }
          }

          if (product == null) continue;

          _items[pid] = CartItem(product: product, unitPrice: unit, qty: qty);
        }
      }
      notifyListeners();
    } catch (e) {
      // ignore load errors
    }
  }

  /// Debug helper: returns the raw saved JSON (or null) from shared prefs.
  Future<String?> debugDumpSavedCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_prefsKey);
    } catch (_) {
      return null;
    }
  }
}
