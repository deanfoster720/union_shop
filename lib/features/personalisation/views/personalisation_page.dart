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

  final _lineControllers =
      List.generate(4, (_) => TextEditingController(), growable: false);
  final _formKey = GlobalKey<FormState>();

  int _qty = 1;
  _PersonalisationOption _selectedOption = _options.first;
  bool _includeUpload = false;

  @override
  void dispose() {
    for (final controller in _lineControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<TextEditingController> get _activeLineControllers =>
      _lineControllers.take(_selectedOption.textLines).toList();

  double get _optionPrice {
    final extraLineCount =
        _selectedOption.textLines > 1 ? _selectedOption.textLines - 1 : 0;
    final lineCost = extraLineCount * _selectedOption.extraLineCost;
    final uploadCost = _selectedOption.supportsUpload && _includeUpload
        ? _selectedOption.uploadSurcharge
        : 0;
    return _selectedOption.basePrice + lineCost + uploadCost;
  }

  double get _totalPrice => _optionPrice * _qty;

  String _priceBreakdown() {
    final parts = <String>[
      'Base £${_selectedOption.basePrice.toStringAsFixed(2)}'
    ];
    if (_selectedOption.textLines > 1 && _selectedOption.extraLineCost > 0) {
      final count = _selectedOption.textLines - 1;
      final total = count * _selectedOption.extraLineCost;
      parts.add('$count extra line(s) +£${total.toStringAsFixed(2)}');
    }
    if (_selectedOption.supportsUpload && _includeUpload) {
      parts.add(
          'Artwork upload +£${_selectedOption.uploadSurcharge.toStringAsFixed(2)}');
    }
    return parts.join(' • ');
  }

  bool _validateSelection() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please complete the highlighted fields.'),
        duration: Duration(seconds: 2),
      ));
    }
    return valid;
  }

  void _addToCart() {
    if (!_validateSelection()) return;

    const product = Product(
      id: 'personalisation',
      name: 'Personalisation',
      price: 3.0,
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
    CartService.instance.addItem(
      product.copyWith(price: _optionPrice),
      toAdd,
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          'Personalisation added to cart ($toAdd) at £${_optionPrice.toStringAsFixed(2)} each'),
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
        child: Form(
          key: _formKey,
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
              Text(
                '£${_optionPrice.toStringAsFixed(2)} tax included',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 6),
              Text(
                _priceBreakdown(),
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const SizedBox(height: 18),
              const Text('Per Line',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    _selectedOption.helper,
                    style: const TextStyle(color: Colors.black54),
                  )),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 240,
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        helperText:
                            'Options change required fields and pricing automatically.',
                      ),
                    ),
                  ),
                ],
              ),
              if (_selectedOption.textLines > 0) ...[
                const SizedBox(height: 12),
                const Text('Personalisation Text',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ...List.generate(_selectedOption.textLines, (index) {
                  final label = 'Line ${index + 1}';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextFormField(
                      controller: _lineControllers[index],
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Enter $label',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '$label is required';
                        }
                        return null;
                      },
                    ),
                  );
                }),
              ],
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
                          final canIncrement =
                              remaining > 0 && _qty < remaining;
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
      ),
      footer: const Footer(),
    );
  }
}
