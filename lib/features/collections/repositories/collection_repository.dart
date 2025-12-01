import '../models/collection.dart';

class CollectionRepository {
  CollectionRepository._();
  static final CollectionRepository instance = CollectionRepository._();

  List<Collection> fetchAll() => _collections;

  Future<List<Collection>> fetchAllAsync() async => _collections;

  // Small helper to find collection by fuzzy name/id
  Collection? findByIdOrName(String idOrName) {
    final key = idOrName.toLowerCase();
    for (final c in _collections) {
      if (c.id == key || c.name.toLowerCase() == key) return c;
    }
    return null;
  }
}

// Predefined collections (moved from CollectionService to allow configuration)
const List<Collection> _collections = [
  Collection(
    id: 'autumn-favourites',
    name: 'Autumn Favourites',
    imageUrl: 'Assets/collection_images/autumn_favourites.png',
    // Products 1-4
    productIds: ['1', '2', '3', '4'],
  ),
  Collection(
    id: 'black-friday-clothing',
    name: 'Black Friday Clothing',
    imageUrl: 'Assets/collection_images/black_friday.png',
    // Products 5-8
    productIds: ['5', '6', '7', '8'],
  ),
  Collection(
    id: 'clothing-original',
    name: 'Clothing - Original',
    imageUrl: 'Assets/collection_images/original_clothing.png',
    // Products 9-12
    productIds: ['9', '10', '11', '12'],
  ),
  Collection(
    id: 'elections-discounts',
    name: 'Elections Discounts',
    imageUrl: 'Assets/collection_images/elections_discount.png',
    // Products 13-16
    productIds: ['13', '14', '15', '16'],
  ),
  Collection(
    id: 'essential-range',
    name: 'Essential Range',
    imageUrl: 'Assets/collection_images/essential_range.png',
    // Products 17-20
    productIds: ['17', '18', '19', '20'],
  ),
];
