import '../models/cart_item.dart';

class CheckoutService {
  CheckoutService._();

  static final CheckoutService instance = CheckoutService._();

  Future<bool> placeOrder(List<CartItem> items) async {
    return items.isNotEmpty;
  }
}
