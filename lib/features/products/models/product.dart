class Product {
  final String id;
  final String name;
  final double price;
  final double? discountedPrice;
  final String description;
  final String? imageUrl;
  final List<String> categories;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.discountedPrice,
    required this.description,
    this.imageUrl,
    required this.categories,
  });

  String get displayPrice {
    final p = discountedPrice ?? price;
    return '£${p.toStringAsFixed(2)}';
  }

  /// Convenience: first category (if any) for places which expect a single
  /// category value.
  String get primaryCategory => categories.isNotEmpty ? categories.first : '';

  bool hasCategory(String category) => categories.contains(category);
}
