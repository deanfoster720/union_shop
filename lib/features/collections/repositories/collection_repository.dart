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
    productIds: ['1', '3', '8'],
  ),
  Collection(
    id: 'black-friday-clothing',
    name: 'Black Friday Clothing',
    productIds: ['1', '2', '3', '4'],
  ),
  Collection(
    id: 'clothing-original',
    name: 'Clothing - Original',
    productIds: ['3', '4'],
  ),
  Collection(
    id: 'elections-discounts',
    name: 'Elections Discounts',
    productIds: ['2', '5', '6'],
  ),
  Collection(
    id: 'essential-range',
    name: 'Essential Range',
    productIds: ['2', '5', '7', '8'],
  ),
];
