import 'package:union_shop/features/products/models/product.dart';

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
        'product': {
          'id': product.id,
          'name': product.name,
          'price': product.price,
          'discountedPrice': product.discountedPrice,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'categories': product.categories,
          'collectionIds': product.collectionIds,
        },
      };

  @override
  String toString() => 'CartItem(${product.name} x $qty @ $unitPrice)';
}
