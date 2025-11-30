import 'dart:math';

import '../models/cart_item.dart';

class CheckoutService {
  CheckoutService._();

  static final CheckoutService instance = CheckoutService._();

  /// Simulate placing an order. Returns `true` on success.
  Future<bool> placeOrder(List<CartItem> items) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Lightweight mock success (80% chance to succeed)
    final roll = Random().nextDouble();
    return roll > 0.2 && items.isNotEmpty;
  }
}
