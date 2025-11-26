import 'package:meta/meta.dart';
import 'product.dart';

class CartItem {
  final Product product;
  final double unitPrice;
  int qty;

  CartItem({
    required this.product,
    required this.unitPrice,
    this.qty = 1,
  });

  double get subtotal => unitPrice * qty;

  Map<String, dynamic> toJson() => {
        'productId': product.id,
        'unitPrice': unitPrice,
        'qty': qty,
      };

  @override
  String toString() => 'CartItem(${product.name} x $qty @ $unitPrice)';
}
