import 'package:flutter/material.dart';
import 'package:union_shop/features/products/models/product.dart';
import 'package:union_shop/core/widgets/base_scaffold.dart';
import 'package:union_shop/core/widgets/footer.dart';
import 'package:union_shop/core/widgets/header.dart';

import 'product_page.dart';

/// A generic skeleton used as the base for shop category pages.

class ShopSkeleton extends StatefulWidget {
  final String title;
  // Accept either list of names (String) or list of Product objects.
  final Iterable<dynamic> items;
  // Optional subtitle widget displayed directly under the title.
  final Widget? subtitle;

  // If provided, ShopSkeleton will render its own filter/sort UI and apply the
  // provided callback to produce the displayed list. If not provided, the
  // caller can supply a custom `filterWidget` instead.
  final Widget? filterWidget;

  // Enable the built-in filter/sort UI (ShopSkeleton will manage selected
  // values and call `applyFilterSort` to obtain the display list).
  final bool enableFilterSort;
  final List<DropdownMenuItem<String>>? filterOptions;
  final List<DropdownMenuItem<String>>? sortOptions;
  final List<dynamic> Function(
      Iterable<dynamic> items, String filter, String sort)? applyFilterSort;

  const ShopSkeleton({
    Key? key,
    required this.title,
    required this.items,
    this.filterWidget,
    this.subtitle,
    this.enableFilterSort = false,
    this.filterOptions,
    this.sortOptions,
    this.applyFilterSort,
  }) : super(key: key);

  @override
  State<ShopSkeleton> createState() => _ShopSkeletonState();
}

class _ShopSkeletonState extends State<ShopSkeleton> {
  String _selectedFilter = 'All';
  String _selectedSort = 'Default';
  // Pagination state: current page index (0-based)
  int _currentPage = 0;
  static const int _itemsPerPage = 6;

  int _calculateCrossAxisCount(double maxWidth) {
    if (maxWidth < 600) return 1;
    if (maxWidth < 900) return 2;
    return 3;
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void _placeholder() {}

  List<dynamic> _computeDisplayItems() {
    if (widget.enableFilterSort && widget.applyFilterSort != null) {
      return widget.applyFilterSort!(
          widget.items, _selectedFilter, _selectedSort);
    }
    // Fallback: just return items as list
    return widget.items.toList();
  }

  Widget _buildFilterWidget() {
    // If caller provided a custom widget, prefer it.
    if (widget.filterWidget != null) return widget.filterWidget!;

    // If built-in filter/sort is enabled, build default controls.
    if (widget.enableFilterSort) {
      final filterItems = widget.filterOptions ??
          const [
            DropdownMenuItem(value: 'All', child: Text('All')),
          ];
      final sortItems = widget.sortOptions ??
          const [
            DropdownMenuItem(value: 'Default', child: Text('Default')),
          ];

      // Ensure selected values are valid (in case options differ)
      if (!filterItems.any((it) => it.value == _selectedFilter)) {
        _selectedFilter = filterItems.first.value ?? 'All';
      }
      if (!sortItems.any((it) => it.value == _selectedSort)) {
        _selectedSort = sortItems.first.value ?? 'Default';
      }

      return Padding(
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
                  value: _selectedFilter,
                  items: filterItems,
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() {
                      _selectedFilter = v;
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
                  value: _selectedSort,
                  items: sortItems,
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() {
                      _selectedSort = v;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final section = Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Text(
              widget.title.toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            // Optional subtitle/message under the title (e.g. sale note)
            if (widget.subtitle != null) ...[
              widget.subtitle!,
              const SizedBox(height: 8),
            ],
            // Either caller's filter widget, or built-in filter controls
            if (widget.filterWidget != null || widget.enableFilterSort) ...[
              _buildFilterWidget(),
              const SizedBox(height: 24),
            ] else ...[
              const SizedBox(height: 36),
            ],
            LayoutBuilder(builder: (context, constraints) {
              final crossAxisCount =
                  _calculateCrossAxisCount(constraints.maxWidth);
              final display = _computeDisplayItems();
              final itemList = display.toList();

              // Pagination: compute total pages and clamp current page
              final int totalPages =
                  (itemList.length / _itemsPerPage).ceil().clamp(1, 9999);
              if (_currentPage >= totalPages) {
                _currentPage = totalPages - 1;
              }

              final int startIndex = _currentPage * _itemsPerPage;
              int endIndex = startIndex + _itemsPerPage;
              if (endIndex > itemList.length) endIndex = itemList.length;
              final pageItems = (startIndex < endIndex)
                  ? itemList.sublist(startIndex, endIndex)
                  : <dynamic>[];

              return Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 48,
                    ),
                    itemCount: pageItems.length,
                    itemBuilder: (context, index) {
                      final item = pageItems[index];
                      if (item is Product) {
                        return _GridProductCard(product: item);
                      }
                      return _TextCard(name: item?.toString() ?? '');
                    },
                  ),
                  // Pagination controls
                  if (totalPages > 1) ...[
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: _currentPage > 0
                              ? () => setState(() => _currentPage -= 1)
                              : null,
                        ),
                        Text('Page ${_currentPage + 1} of $totalPages'),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: _currentPage < totalPages - 1
                              ? () => setState(() => _currentPage += 1)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ],
              );
            }),
          ],
        ),
      ),
    );

    return BaseScaffold(
      header: Header(
        onLogoTap: () => _navigateToHome(context),
        onPlaceholderPressed: _placeholder,
      ),
      body: Column(children: [section]),
      footer: const Footer(),
    );
  }
}

class _TextCard extends StatelessWidget {
  final String name;

  const _TextCard({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.grey[200],
            ),
          ),
          Positioned.fill(
            child: Container(color: const Color.fromRGBO(0, 0, 0, 0.35)),
          ),
          Center(
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridProductCard extends StatelessWidget {
  final Product product;

  const _GridProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductPage(product: product)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: product.imageUrl != null
                ? Image.asset(
                    product.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              color: Colors.grey),
                        ),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child:
                          Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                product.name,
                style: const TextStyle(fontSize: 14, color: Colors.black),
                maxLines: 2,
              ),
              const SizedBox(height: 6),
              product.discountedPrice != null
                  ? Row(
                      children: [
                        Text(
                          '£${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '£${product.discountedPrice!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      product.displayPrice,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
