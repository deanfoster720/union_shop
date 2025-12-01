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
        imageUrl: 'Assets/product_images/limited_edition_hoodie.png',
        categories: ['Popular', 'Clothing'],
        collectionIds: ['autumn-favourites']),
    Product(
        id: '2',
        name: 'Essential T-shirt',
        price: 12.00,
        discountedPrice: 8.99,
        description:
            'Soft 100% cotton essential tee with a subtle Union print. Breathable and easy to wear every day.',
        imageUrl: 'Assets/product_images/essential_tshirt.png',
        categories: ['Popular', 'Clothing'],
        collectionIds: ['autumn-favourites']),
    Product(
        id: '3',
        name: 'Signature Hoodie',
        price: 39.99,
        description:
            'Classic pullover hoodie with a soft brushed interior and bold Signature logo.',
        imageUrl: 'Assets/product_images/signature_hoodie.png',
        categories: ['Clothing'],
        collectionIds: ['autumn-favourites']),
    Product(
        id: '4',
        name: 'Signature T-shirt',
        price: 14.99,
        description:
            'Premium cotton tee featuring the Signature design — comfortable and hard-wearing.',
        imageUrl: 'Assets/product_images/signature_tshirt.png',
        categories: ['Clothing'],
        collectionIds: ['autumn-favourites']),
    Product(
        id: '5',
        name: 'Portsmouth City Postcard',
        price: 1.50,
        description:
            'High-quality postcard featuring a scenic shot of Portsmouth — perfect as a keepsake or gift.',
        imageUrl: 'Assets/product_images/portsmouth_postcard.png',
        categories: ['Merchandise'],
        collectionIds: ['black-friday-clothing']),
    Product(
        id: '6',
        name: 'Portsmouth City Magnet',
        price: 2.50,
        description:
            'Small enamel magnet with Portsmouth landmark artwork — ideal for fridges and lockers.',
        imageUrl: 'Assets/product_images/portsmouth_magnet.png',
        categories: ['Merchandise'],
        collectionIds: ['black-friday-clothing']),
    Product(
        id: '7',
        name: 'Portsmouth City Bookmark',
        price: 1.25,
        description:
            'Durable cardstock bookmark featuring Portsmouth illustrations.',
        imageUrl: 'Assets/product_images/portsmouth_bookmark.png',
        categories: ['Merchandise'],
        collectionIds: ['black-friday-clothing']),
    Product(
        id: '8',
        name: 'Portsmouth City Notebook',
        price: 6.99,
        description:
            'A5 notebook with lined pages and a Portsmouth cover design — great for notes and sketches.',
        imageUrl: 'Assets/product_images/portsmouth_city_notebook.png',
        categories: ['Merchandise'],
        collectionIds: ['black-friday-clothing']),
    Product(
        id: '9',
        name: 'Union Cap',
        price: 12.99,
        description:
            'Structured cap with embroidered Union logo — adjustable fit.',
        imageUrl: 'Assets/product_images/essential_tshirt.png',
        categories: ['Clothing'],
        collectionIds: ['clothing-original']),
    Product(
        id: '10',
        name: 'Union Beanie',
        price: 9.99,
        description:
            'Knitted beanie with a folded cuff and Union patch — warm and soft.',
        imageUrl: 'Assets/product_images/essential_tshirt.png',
        categories: ['Clothing'],
        collectionIds: ['clothing-original']),
    Product(
        id: '11',
        name: 'Union Socks (Pair)',
        price: 4.99,
        description:
            'Comfortable cotton blend socks with subtle Union branding.',
        imageUrl: 'Assets/product_images/essential_tshirt.png',
        categories: ['Clothing'],
        collectionIds: ['clothing-original']),
    Product(
        id: '12',
        name: 'Campus Mug',
        price: 7.50,
        description: 'Ceramic mug with Union crest — dishwasher safe.',
        imageUrl: 'Assets/product_images/essential_tshirt.png',
        categories: ['Merchandise'],
        collectionIds: ['clothing-original']),
    Product(
        id: '13',
        name: 'Union Tote Bag',
        price: 8.99,
        description:
            'Reusable cotton tote bag with large Union print — perfect for shopping.',
        imageUrl: 'Assets/product_images/essential_tshirt.png',
        categories: ['Merchandise'],
        collectionIds: ['elections-discounts']),
    Product(
        id: '14',
        name: 'Limited Edition Poster',
        price: 15.00,
        description:
            'A2 limited edition poster — high-quality print, numbered run.',
        imageUrl: 'Assets/product_images/essential_tshirt.png',
        categories: ['Merchandise'],
        collectionIds: ['elections-discounts']),
    Product(
        id: '15',
        name: 'Graduation Scarf',
        price: 19.99,
        description: 'Commemorative scarf with graduation year embroidery.',
        imageUrl: 'Assets/product_images/essential_tshirt.png',
        categories: ['Clothing'],
        collectionIds: ['elections-discounts']),
    Product(
        id: '16',
        name: 'Pride Badge Pack',
        price: 3.99,
        description:
            'Set of 5 enamel badges celebrating Pride — limited stock.',
        imageUrl: 'Assets/product_images/essential_tshirt.png',
        categories: ['Merchandise'],
        collectionIds: ['elections-discounts']),
    Product(
        id: '17',
        name: 'Halloween Mask',
        price: 6.49,
        description: 'Reusable face mask with Halloween-themed print.',
        imageUrl: 'Assets/product_images/essential_tshirt.png',
        categories: ['Merchandise'],
        collectionIds: ['essential-range']),
    Product(
        id: '18',
        name: 'Study Desk Lamp',
        price: 22.00,
        description:
            'Compact LED desk lamp with adjustable brightness and USB power.',
        imageUrl: 'Assets/product_images/essential_tshirt.png',
        categories: ['Merchandise'],
        collectionIds: ['essential-range']),
    Product(
        id: '19',
        name: 'Campus Hoodie (Unisex)',
        price: 42.00,
        discountedPrice: 29.99,
        description: 'Unisex campus hoodie with screen-printed Union artwork.',
        imageUrl: 'Assets/product_images/essential_tshirt.png',
        categories: ['Popular', 'Clothing'],
        collectionIds: ['essential-range']),
    Product(
        id: '20',
        name: 'Water Bottle',
        price: 10.99,
        description: 'Insulated stainless steel water bottle with Union logo.',
        imageUrl: 'Assets/product_images/essential_tshirt.png',
        categories: ['Merchandise'],
        collectionIds: ['essential-range']),
  ];
}
