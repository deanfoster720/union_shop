import 'package:flutter/material.dart';
import 'package:union_shop/views/shop_skeleton.dart';
import 'package:union_shop/repositories/product_repository.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  String _filter = 'All';
  String _sort = 'Default';

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
    final filtered = productsForDisplay(all);

    final filterWidget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        alignment: WrapAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
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
          Row(
            mainAxisSize: MainAxisSize.min,
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

    return ShopSkeleton(
      title: 'Sale Items',
      items: filtered,
      filterWidget: filterWidget,
    );
  }
}
