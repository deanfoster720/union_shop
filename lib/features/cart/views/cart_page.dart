import 'package:flutter/material.dart';
import 'package:union_shop/core/widgets/base_scaffold.dart';
import 'package:union_shop/core/widgets/footer.dart';
import 'package:union_shop/core/widgets/header.dart';

import '../services/cart_service.dart';
import '../services/checkout_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isPlacingOrder = false;
  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void placeholderCallbackForButtons() {}

  Future<void> _handleCheckout() async {
    final items = CartService.instance.items;
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add items to cart before checkout')),
      );
      return;
    }

    setState(() {
      _isPlacingOrder = true;
    });

    try {
      final success = await CheckoutService.instance.placeOrder(items);
      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully!')),
        );
        CartService.instance.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Something went wrong placing your order. Try again.'),
          ),
        );
      }
    } catch (err) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Checkout failed. Please try again later.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingOrder = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      header: Header(
        onLogoTap: () => navigateToHome(context),
        onPlaceholderPressed: placeholderCallbackForButtons,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: AnimatedBuilder(
          animation: CartService.instance,
          builder: (context, _) {
            final items = CartService.instance.items;
            if (items.isEmpty) {
              return const Center(
                child: Text('Your cart is empty'),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Cart',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[200],
                          child: item.product.imageUrl != null
                              ? Image.network(
                                  item.product.imageUrl!,
                                  fit: BoxFit.cover,
                                )
                              : const Center(
                                  child: Icon(Icons.image_not_supported),
                                ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              item.product.discountedPrice != null
                                  ? Row(
                                      children: [
                                        Text(
                                          '£${item.product.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '£${item.product.discountedPrice!.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      'Unit: £${item.unitPrice.toStringAsFixed(2)}',
                                      style:
                                          const TextStyle(color: Colors.grey)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                    onPressed: () {
                                      final newQty = item.qty - 1;
                                      if (newQty >= 1) {
                                        CartService.instance.updateQty(
                                          item.product.id,
                                          newQty,
                                        );
                                      }
                                    },
                                  ),
                                  Text('${item.qty}'),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                    ),
                                    onPressed: () {
                                      if (item.qty < CartService.maxPerItem) {
                                        CartService.instance.updateQty(
                                          item.product.id,
                                          item.qty + 1,
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text('Maximum 5 per item'),
                                          duration: Duration(seconds: 2),
                                        ));
                                      }
                                    },
                                  ),
                                  const Spacer(),
                                  Text(
                                    '£${item.subtotal.toStringAsFixed(2)}',
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      CartService.instance.removeItem(
                                        item.product.id,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '£${CartService.instance.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _isPlacingOrder ? null : _handleCheckout,
                      child: _isPlacingOrder
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Checkout'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () {
                        CartService.instance.clear();
                      },
                      child: const Text('Clear Cart'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      footer: const Footer(),
    );
  }
}
