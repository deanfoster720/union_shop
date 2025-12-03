import 'package:flutter/material.dart';
import 'package:union_shop/features/about/views/about_page.dart';
import 'package:union_shop/features/about/views/about_print_shack_page.dart';
import 'package:union_shop/features/cart/views/cart_page.dart';
import 'package:union_shop/features/products/views/shop_page.dart';
import 'package:union_shop/features/personalisation/views/personalisation_page.dart';

class Header extends StatefulWidget {
  final VoidCallback onLogoTap;
  final VoidCallback onPlaceholderPressed;

  const Header({
    Key? key,
    required this.onLogoTap,
    required this.onPlaceholderPressed,
  }) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool? _menuOpen = false;
  bool? _shopOpen = false;
  bool? _printOpen = false;

  List<_NavItem> get _navItems => [
        _NavItem(label: 'Home', onTap: _navigateToHome),
        _NavItem(label: 'Shop', onTap: () => _navigateToPage(ShopPage())),
        _NavItem.withChildren(label: 'The Print Shack', children: [
          _NavItem(
            label: 'About',
            onTap: () => _navigateToPage(const PrintShackPage()),
          ),
          _NavItem(
            label: 'Personalisation',
            onTap: () => _navigateToPage(const PersonalisationPage()),
          ),
        ]),
        _NavItem(label: 'SALE!', onTap: () => _navigateToNamed('/sale')),
        _NavItem(
          label: 'About',
          onTap: () => _navigateToPage(const AboutPage()),
        ),
      ];

  void _toggleMenu() {
    setState(() {
      final newVal = !(_menuOpen ?? false);
      _menuOpen = newVal;
      if (!newVal) {
        _shopOpen = false;
        _printOpen = false;
      }
    });
  }

  void _closeMenus() {
    setState(() {
      _menuOpen = false;
      _shopOpen = false;
      _printOpen = false;
    });
  }

  void _navigateToHome() {
    _closeMenus();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void _navigateToPage(Widget page) {
    _closeMenus();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _navigateToNamed(String route) {
    _closeMenus();
    Navigator.pushNamed(context, route);
  }

  void _openSignIn() {
    Navigator.pushNamed(context, '/sign_in');
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartPage()),
    );
  }

  List<Widget> _buildDesktopNavItems() {
    final items = <Widget>[];
    final navItems = _navItems;
    for (var i = 0; i < navItems.length; i++) {
      items.add(_buildDesktopNavItem(navItems[i]));
      if (i != navItems.length - 1) {
        items.add(const SizedBox(width: 8));
      }
    }
    return items;
  }

  Widget _buildDesktopNavItem(_NavItem item) {
    if (item.children.isEmpty) {
      return _NavButton(label: item.label, onPressed: item.onTap);
    }

    return PopupMenuButton<_NavItem>(
      offset: const Offset(0, 40),
      itemBuilder: (ctx) => item.children
          .map(
            (child) => PopupMenuItem<_NavItem>(
              value: child,
              child: Text(child.label),
            ),
          )
          .toList(),
      onSelected: (value) => value.onTap(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          item.label,
          style: const TextStyle(
              color: Color(0xFF4d2963),
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  List<Widget> _buildMobileNavItems() {
    return _navItems
        .map((item) => item.children.isEmpty
            ? _buildMobileButton(item)
            : _buildMobileSubmenu(item))
        .toList();
  }

  Widget _buildMobileButton(_NavItem item) {
    return TextButton(
      onPressed: item.onTap,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(item.label),
      ),
    );
  }

  Widget _buildMobileSubmenu(_NavItem item) {
    final isOpen = _isExpanded(item);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextButton(
          onPressed: () => _toggleSubmenu(item),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.label),
              Builder(
                builder: (ctx) {
                  final isMobile = MediaQuery.of(ctx).size.width < 600;
                  return isMobile
                      ? Icon(isOpen ? Icons.expand_less : Icons.expand_more)
                      : const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
        if (isOpen)
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: item.children
                  .map((child) => _buildMobileButton(child))
                  .toList(),
            ),
          ),
      ],
    );
  }

  bool _isExpanded(_NavItem item) {
    switch (item.label) {
      case 'Shop':
        return _shopOpen ?? false;
      case 'The Print Shack':
        return _printOpen ?? false;
      default:
        return false;
    }
  }

  void _toggleSubmenu(_NavItem item) {
    setState(() {
      final newVal = !_isExpanded(item);
      _shopOpen = item.label == 'Shop' ? newVal : false;
      _printOpen = item.label == 'The Print Shack' ? newVal : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Top banner: dynamic height based on content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            color: const Color(0xFF4d2963),
            child: const Text(
              'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),

          // Main header row: single responsive bar
          SizedBox(
            height: 72,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 600;

                  if (isDesktop) {
                    // Desktop: logo (left), nav links (center), icons (right)
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: widget.onLogoTap,
                          child: Image.network(
                            'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
                            height: 18,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                width: 18,
                                height: 18,
                                child: const Center(),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _buildDesktopNavItems(),
                            ),
                          ),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _IconRow(
                                onSearch: widget.onPlaceholderPressed,
                                onPerson: _openSignIn,
                                onCart: _openCart,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  // Mobile: logo on left, icons centered-right, menu button far right
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: widget.onLogoTap,
                        child: Image.asset(
                          'Assets/upsu_logo.png',
                          height: 18,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              width: 18,
                              height: 18,
                              child: const Center(),
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: _IconRow(
                          onSearch: widget.onPlaceholderPressed,
                          onPerson: _openSignIn,
                          onCart: _openCart,
                        ),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: Icon(
                          (_menuOpen ?? false) ? Icons.close : Icons.menu,
                          color: Colors.grey,
                        ),
                        onPressed: _toggleMenu,
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Dropdown menu for mobile when open
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 600;
              if (isDesktop || !(_menuOpen ?? false)) {
                return const SizedBox.shrink();
              }

              return Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _buildMobileNavItems(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final String label;
  final VoidCallback onTap;
  final List<_NavItem> children;

  _NavItem({required this.label, required this.onTap}) : children = const [];

  _NavItem.withChildren({required this.label, required this.children})
      : onTap = _noop;
}

void _noop() {}

class _NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _NavButton({Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF4d2963),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      child: Text(label),
    );
  }
}

class _IconRow extends StatelessWidget {
  final VoidCallback onSearch;
  final VoidCallback onPerson;
  final VoidCallback onCart;

  const _IconRow({
    Key? key,
    required this.onSearch,
    required this.onPerson,
    required this.onCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(
            Icons.search,
            size: 18,
            color: Colors.grey,
          ),
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
          onPressed: onSearch,
        ),
        IconButton(
          icon: const Icon(
            Icons.person_outline,
            size: 18,
            color: Colors.grey,
          ),
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
          onPressed: onPerson,
        ),
        IconButton(
          icon: const Icon(
            Icons.shopping_bag_outlined,
            size: 18,
            color: Colors.grey,
          ),
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
          onPressed: onCart,
        ),
      ],
    );
  }
}
