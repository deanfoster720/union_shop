import '../models/product.dart';

class ProductRepository {
  ProductRepository._();
  static final ProductRepository instance = ProductRepository._();

  List<Product> fetchAll() => _products;

  Future<List<Product>> fetchAllAsync() async => _products;

  static const List<Product> _products = [
    Product(
      id: '1',
      name: 'Limited Edition Essential Zip Hoodie',
      price: 45.00,
      discountedPrice: 34.99,
      description:
          'Limited edition zip-up hoodie with embroidered Union logo. Midweight fleece for warmth and durability.',
      imageUrl: 'https://example.com/images/hoodie.png',
    ),
    Product(
      id: '2',
      name: 'Essential T-shirt',
      price: 12.00,
      discountedPrice: 8.99,
      description:
          'Soft 100% cotton essential tee with a subtle Union print. Breathable and easy to wear every day.',
      imageUrl: 'https://example.com/images/tshirt.png',
    ),
    Product(
      id: '3',
      name: 'Signature Hoodie',
      price: 39.99,
      description:
          'Classic pullover hoodie with a soft brushed interior and bold Signature logo.',
      imageUrl: null,
    ),
    Product(
      id: '4',
      name: 'Signature T-shirt',
      price: 14.99,
      description:
          'Premium cotton tee featuring the Signature design — comfortable and hard-wearing.',
      imageUrl: null,
    ),
    Product(
      id: '5',
      name: 'Portsmouth City Postcard',
      price: 1.50,
      description:
          'High-quality postcard featuring a scenic shot of Portsmouth — perfect as a keepsake or gift.',
      imageUrl: null,
    ),
    Product(
      id: '6',
      name: 'Portsmouth City Magnet',
      price: 2.50,
      description:
          'Small enamel magnet with Portsmouth landmark artwork — ideal for fridges and lockers.',
      imageUrl: null,
    ),
    Product(
      id: '7',
      name: 'Portsmouth City Bookmark',
      price: 1.25,
      description:
          'Durable cardstock bookmark featuring Portsmouth illustrations.',
      imageUrl: null,
    ),
    Product(
      id: '8',
      name: 'Portsmouth City Notebook',
      price: 6.99,
      description:
          'A5 notebook with lined pages and a Portsmouth cover design — great for notes and sketches.',
      imageUrl: null,
    ),
  ];
}
