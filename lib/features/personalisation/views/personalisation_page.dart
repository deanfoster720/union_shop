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

class _PersonalisationPageState extends State<PersonalisationPage> {
  String _option = 'One Lines of Text';
  final _line1Controller = TextEditingController();
  int _qty = 1;

  static const _price = 3.0;

  @override
  void dispose() {
    _line1Controller.dispose();
    super.dispose();
  }

  void _addToCart() {
    // We use a single static product id for personalisation so cart limits apply
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
            // Personalised image preview
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

            // Per line block
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
                    initialValue: _option,
                    items: const [
                      DropdownMenuItem(
                          value: 'One Lines of Text',
                          child: Text('One Lines of Text')),
                      DropdownMenuItem(
                          value: 'Two Lines of Text',
                          child: Text('Two Lines of Text')),
                      DropdownMenuItem(
                          value: 'Three Lines of Text',
                          child: Text('Three Lines of Text')),
                      DropdownMenuItem(
                          value: 'Four Lines of Text',
                          child: Text('Four Lines of Text')),
                      DropdownMenuItem(
                          value: 'Small Logo (Chest)',
                          child: Text('Small Logo (Chest)')),
                      DropdownMenuItem(
                          value: 'Large Logo (Back)',
                          child: Text('Large Logo (Back)')),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _option = v);
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
