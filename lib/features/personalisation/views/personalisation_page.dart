import 'package:flutter/material.dart';
import 'package:union_shop/core/widgets/base_scaffold.dart';
import 'package:union_shop/core/widgets/footer.dart';
import 'package:union_shop/core/widgets/header.dart';

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
    // Placeholder implementation for now
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Personalisation added to cart ($_qty)'),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      header: Header(
        onLogoTap: () => Navigator.pop(context),
        onPlaceholderPressed: () {},
      ),
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
            // Placeholder image box
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: const Center(
                child: Icon(Icons.image, size: 48, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '£3.00 tax included',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 18),

            // Per line block
            const Text(
              'Per Line',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Expanded(child: Text('One Line of Text')),
                const SizedBox(width: 12),
                SizedBox(
                  width: 220,
                  child: DropdownButtonFormField<String>(
                    value: _option,
                    items: const [
                      DropdownMenuItem(
                        value: 'One Lines of Text',
                        child: Text('One Lines of Text'),
                      ),
                      DropdownMenuItem(
                        value: 'Two Lines of Text',
                        child: Text('Two Lines of Text'),
                      ),
                      DropdownMenuItem(
                        value: 'Three Lines of Text',
                        child: Text('Three Lines of Text'),
                      ),
                      DropdownMenuItem(
                        value: 'Four Lines of Text',
                        child: Text('Four Lines of Text'),
                      ),
                      DropdownMenuItem(
                        value: 'Small Logo (Chest)',
                        child: Text('Small Logo (Chest)'),
                      ),
                      DropdownMenuItem(
                        value: 'Large Logo (Back)',
                        child: Text('Large Logo (Back)'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _option = v);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Text(
              'Personalisation Line 1',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _line1Controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter text',
              ),
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  'Quantity',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
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
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() => _qty++);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _addToCart,
                  child: const Text('ADD TO CART'),
                ),
              ],
            ),
          ],
        ),
      ),
      footer: const Footer(),
    );
  }
}
