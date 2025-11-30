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
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Personalisation added to cart (placeholder)'),
      duration: Duration(seconds: 2),
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
          ],
        ),
      ),
      footer: const Footer(),
    );
  }
}
