import 'package:flutter/material.dart';
import '../views/cart_page.dart';

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
  bool _menuOpen = false;
  bool _shopOpen = false;

  void _toggleMenu() {
    setState(() => _menuOpen = !_menuOpen);
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _NavButton(label: 'Home', onPressed: () {}),
                              const SizedBox(width: 8),
                              // Shop with desktop popup submenu
                              PopupMenuButton<int>(
                                offset: const Offset(0, 40),
                                itemBuilder: (ctx) => const [
                                  PopupMenuItem(
                                      value: 0, child: Text('Clothing')),
                                  PopupMenuItem(
                                      value: 1, child: Text('Merchandise')),
                                  PopupMenuItem(
                                      value: 2, child: Text('Halloween')),
                                  PopupMenuItem(
                                      value: 3,
                                      child:
                                          Text('Signature & Essential Range')),
                                  PopupMenuItem(
                                      value: 4,
                                      child:
                                          Text('Portsmouth City Collection')),
                                  PopupMenuItem(
                                      value: 5,
                                      child: Text('Pride Collection')),
                                  PopupMenuItem(
                                      value: 6, child: Text('Graduation')),
                                ],
                                onSelected: (_) {},
                                child: TextButton(
                                  onPressed: null,
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF4d2963),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  child: const Text('Shop'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _NavButton(
                                  label: 'The Print Shack', onPressed: () {}),
                              const SizedBox(width: 8),
                              _NavButton(label: 'SALE!', onPressed: () {}),
                              const SizedBox(width: 8),
                              _NavButton(label: 'About', onPressed: () {}),
                            ],
                          ),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Row(
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
                                onPressed: widget.onPlaceholderPressed,
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
                                onPressed: () {
                                  Navigator.pushNamed(context, '/sign_in');
                                },
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
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const CartPage()),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.menu,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                onPressed: widget.onPlaceholderPressed,
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
                      const Spacer(),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Row(
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
                              onPressed: widget.onPlaceholderPressed,
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
                              onPressed: () {
                                Navigator.pushNamed(context, '/sign_in');
                              },
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const CartPage()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: Icon(
                          _menuOpen ? Icons.close : Icons.menu,
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
              if (isDesktop || !_menuOpen) return const SizedBox.shrink();

              return Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                      onPressed: () => setState(() => _menuOpen = false),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Home'),
                      ),
                    ),
                    // Shop entry with expandable submenu on mobile
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextButton(
                          onPressed: () =>
                              setState(() => _shopOpen = !_shopOpen),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Shop'),
                              Icon(_shopOpen
                                  ? Icons.expand_less
                                  : Icons.expand_more),
                            ],
                          ),
                        ),
                        if (_shopOpen) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextButton(
                                  onPressed: () =>
                                      setState(() => _menuOpen = false),
                                  child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Clothing')),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      setState(() => _menuOpen = false),
                                  child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Merchandise')),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      setState(() => _menuOpen = false),
                                  child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Halloween')),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      setState(() => _menuOpen = false),
                                  child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child:
                                          Text('Signature & Essential Range')),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      setState(() => _menuOpen = false),
                                  child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child:
                                          Text('Portsmouth City Collection')),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      setState(() => _menuOpen = false),
                                  child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Pride Collection')),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      setState(() => _menuOpen = false),
                                  child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Graduation')),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    TextButton(
                      onPressed: () => setState(() => _menuOpen = false),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('The Print Shack'),
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _menuOpen = false),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('SALE!'),
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _menuOpen = false),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('About'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

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
