class Collection {
  final String id;
  final String name;
  final String? description;
  final List<String> productIds;

  const Collection({
    required this.id,
    required this.name,
    this.description,
    required this.productIds,
  });

  @override
  String toString() => name;
}
