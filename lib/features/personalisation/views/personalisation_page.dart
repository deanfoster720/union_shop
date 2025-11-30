import 'package:flutter/material.dart';
import 'package:union_shop/core/widgets/base_scaffold.dart';
import 'package:union_shop/core/widgets/footer.dart';
import 'package:union_shop/core/widgets/header.dart';
import 'package:union_shop/features/cart/services/cart_service.dart';
import 'package:union_shop/features/products/models/product.dart';

class PersonalisationPage extends StatefulWidget {
  const PersonalisationPage({Key? key}) : super(key: key);

  @override
  State<PersonalisationPage> createState() => _PersonalisationPageState();
}

class _PersonalisationOption {
  final String id;
  final String label;
  final double basePrice;
  final int textLines;
  final double extraLineCost;
  final bool supportsUpload;
  final double uploadSurcharge;
  final String helper;

  const _PersonalisationOption({
    required this.id,
    required this.label,
    required this.basePrice,
    required this.textLines,
    this.extraLineCost = 0,
    this.supportsUpload = false,
    this.uploadSurcharge = 0,
    this.helper = '',
  });
}

class _PersonalisationPageState extends State<PersonalisationPage> {
  static const _options = [
    _PersonalisationOption(
      id: 'one-line',
      label: 'One Line of Text',
      basePrice: 3.0,
      textLines: 1,
      helper: 'One stitched line included.',
    ),
    _PersonalisationOption(
      id: 'two-lines',
      label: 'Two Lines of Text',
      basePrice: 3.0,
      textLines: 2,
      extraLineCost: 1.25,
      helper: 'Adds a second line (+£1.25) for job titles or teams.',
    ),
    _PersonalisationOption(
      id: 'three-lines',
      label: 'Three Lines of Text',
      basePrice: 3.0,
      textLines: 3,
      extraLineCost: 1.25,
      helper: 'Three stitched lines (+£1.25 per extra line).',
    ),
    _PersonalisationOption(
      id: 'four-lines',
      label: 'Four Lines of Text',
      basePrice: 3.0,
      textLines: 4,
      extraLineCost: 1.25,
      helper: 'Maximum coverage (+£1.25 per extra line).',
    ),
    _PersonalisationOption(
      id: 'small-logo',
      label: 'Small Logo (Chest)',
      basePrice: 5.0,
      textLines: 0,
      supportsUpload: true,
      uploadSurcharge: 2.0,
      helper:
          'Upload-ready artwork with a small stitch area (+£2 for upload prep).',
    ),
    _PersonalisationOption(
      id: 'large-logo',
      label: 'Large Logo (Back)',
      basePrice: 7.0,
      textLines: 0,
      supportsUpload: true,
      uploadSurcharge: 3.0,
      helper: 'Best for high-impact branding (+£3 for upload prep).',
    ),
  ];

  final _line1Controller = TextEditingController();
  int _qty = 1;

  static const _price = 3.0;

  // New: typed selected option
  _PersonalisationOption _selectedOption = _options.first;

  @override
  void dispose() {
    _line1Controller.dispose();
    super.dispose();
  }

  void _addToCart() {
    const product = Product(
      id: 'personalisation',
      name: 'Personalisation',
      price: _price,
      description: 'Personalisation option',
    );

    final existing = CartService.instance.qtyFor(product.id);
    final allowed = CartService.maxPerItem - existing;
    if (allowed <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'You already have the maximum personalisation items in your cart.'),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    final toAdd = _qty > allowed ? allowed : _qty;
    CartService.instance.addItem(product, toAdd);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Personalisation added to cart ($toAdd)'),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      header: Header(
          onLogoTap: () => Navigator.pop(context), onPlaceholderPressed: () {}),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personalisation',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[200],
                child: Image.asset(
                  'Assets/personalised_image.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.broken_image,
                          size: 48, color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text('£3.00 tax included',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 18),
            const Text('Per Line',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Expanded(child: Text('One Line of Text')),
                const SizedBox(width: 12),
                SizedBox(
                  width: 220,
                  child: DropdownButtonFormField<String>(
                    value: _selectedOption.id,
                    items: _options
                        .map(
                          (option) => DropdownMenuItem(
                            value: option.id,
                            child: Text(option.label),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() {
                        _selectedOption =
                            _options.firstWhere((option) => option.id == v);
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Personalisation Line 1',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _line1Controller,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter text'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Quantity',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: _qty > 1
                            ? () {
                                setState(() => _qty--);
                              }
                            : null,
                      ),
                      Text('$_qty'),
                      Builder(builder: (context) {
                        final inCart =
                            CartService.instance.qtyFor('personalisation');
                        final remaining = CartService.maxPerItem - inCart;
                        final canIncrement = remaining > 0 && _qty < remaining;
                        return IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: canIncrement
                              ? () {
                                  setState(() => _qty++);
                                }
                              : null,
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                    onPressed: _addToCart, child: const Text('ADD TO CART')),
              ],
            ),
          ],
        ),
      ),
      footer: const Footer(),
    );
  }
}
