class Product {
  final String id;
  final String name;
  final double price;
  final double? discountedPrice;
  final String description;
  final String? imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.discountedPrice,
    required this.description,
    this.imageUrl,
  });

  String get displayPrice {
    final p = discountedPrice ?? price;
    return '£${p.toStringAsFixed(2)}';
  }
}
