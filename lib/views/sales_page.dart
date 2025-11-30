import 'package:flutter/material.dart';
import 'package:union_shop/widgets/base_scaffold.dart';
import 'package:union_shop/widgets/header.dart';
import 'package:union_shop/widgets/footer.dart';
import 'package:union_shop/repositories/product_repository.dart';
import 'package:union_shop/widgets/product_card.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  String _filter = 'All';
  String _sort = 'Default';

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void placeholderCallbackForButtons() {}

  List productsForDisplay(List all) {
    // Start with sale items only
    var list = all.where((p) => p.discountedPrice != null).toList();

    // Apply filter
    if (_filter == 'Under £5') {
      list = list.where((p) => p.discountedPrice! < 5.0).toList();
    } else if (_filter == '£5 - £20') {
      list = list
          .where((p) => p.discountedPrice! >= 5.0 && p.discountedPrice! <= 20.0)
          .toList();
    } else if (_filter == 'Over £20') {
      list = list.where((p) => p.discountedPrice! > 20.0).toList();
    }

    // Apply sort
    if (_sort == 'Price: Low → High') {
      list.sort((a, b) => a.discountedPrice!.compareTo(b.discountedPrice!));
    } else if (_sort == 'Price: High → Low') {
      list.sort((a, b) => b.discountedPrice!.compareTo(a.discountedPrice!));
    } else if (_sort == 'Name: A → Z') {
      list.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sort == 'Name: Z → A') {
      list.sort((a, b) => b.name.compareTo(a.name));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final all = ProductRepository.instance.fetchAll();
    final headerSection = Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Sale Items',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Discounted products and special offers. Browse while stocks last!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );

    final filtered = productsForDisplay(all);

    final filterSortControls = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Filter By
          Row(
            children: [
              const Text('FILTER BY: ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _filter,
                items: const [
                  DropdownMenuItem(value: 'All', child: Text('All')),
                  DropdownMenuItem(value: 'Under £5', child: Text('Under £5')),
                  DropdownMenuItem(value: '£5 - £20', child: Text('£5 - £20')),
                  DropdownMenuItem(value: 'Over £20', child: Text('Over £20')),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    _filter = v;
                  });
                },
              ),
            ],
          ),

          // Sort By
          Row(
            children: [
              const Text('SORT BY: ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _sort,
                items: const [
                  DropdownMenuItem(value: 'Default', child: Text('Default')),
                  DropdownMenuItem(
                      value: 'Price: Low → High',
                      child: Text('Price: Low → High')),
                  DropdownMenuItem(
                      value: 'Price: High → Low',
                      child: Text('Price: High → Low')),
                  DropdownMenuItem(
                      value: 'Name: A → Z', child: Text('Name: A → Z')),
                  DropdownMenuItem(
                      value: 'Name: Z → A', child: Text('Name: Z → A')),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    _sort = v;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );

    final productsGrid = Padding(
      padding: const EdgeInsets.all(24.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: MediaQuery.of(context).size.width > 800 ? 3 : 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: filtered.map((p) => ProductCard(product: p)).toList(),
      ),
    );

    return BaseScaffold(
      header: Header(
        onLogoTap: () => navigateToHome(context),
        onPlaceholderPressed: placeholderCallbackForButtons,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerSection,
          filterSortControls,
          const SizedBox(height: 12),
          productsGrid,
        ],
      ),
      footer: const Footer(),
    );
  }
}
