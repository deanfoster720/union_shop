import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/features/cart/services/cart_service.dart';
import 'package:union_shop/features/personalisation/services/personalisation_service.dart';

void main() {
  final service = PersonalisationService(cartService: CartService.instance);

  setUp(() {
    CartService.instance.clear();
  });

  test('calculates price breakdown for multi-line text', () {
    final option = PersonalisationService.options
        .firstWhere((element) => element.id == 'three-lines');
    final selection = PersonalisationSelection(
      option: option,
      includeUpload: false,
      lines: const ['Name', 'Role', 'Extra'],
    );

    expect(service.optionPrice(option, includeUpload: false), 5.5);
    expect(
      service.priceBreakdown(option, includeUpload: false),
      'Base £3.00 • 2 extra line(s) +£2.50',
    );
    expect(service.totalPrice(selection), 5.5);
  });

  test('requires upload for logo options', () {
    final option = PersonalisationService.options
        .firstWhere((element) => element.id == 'small-logo');
    final selection = PersonalisationSelection(
      option: option,
      includeUpload: false,
      lines: const [],
    );

    final validation = service.validateSelection(selection);
    expect(validation.isValid, isFalse);
    expect(
      validation.message,
      'Enable artwork upload to proceed with logo options.',
    );
  });

  test('clamps add to cart to max per item', () {
    final option = PersonalisationService.options
        .firstWhere((element) => element.id == 'large-logo');
    final selection = PersonalisationSelection(
      option: option,
      includeUpload: true,
      lines: const [],
      qty: CartService.maxPerItem + 2,
    );

    final result = service.addToCart(selection);

    expect(result.success, isTrue);
    expect(result.addedQty, CartService.maxPerItem);
    expect(
      CartService.instance.qtyFor(service.productId(selection)),
      CartService.maxPerItem,
    );
  });

  test('builds product config key and id from selection', () {
    final option = PersonalisationService.options
        .firstWhere((element) => element.id == 'two-lines');
    final selection = PersonalisationSelection(
      option: option,
      includeUpload: true,
      lines: const ['Alice', 'Team Lead'],
    );

    expect(
      service.productConfigKey(selection),
      'two-lines:upload:Alice:Team Lead',
    );
    expect(
      service.productId(selection),
      'personalisation-two-lines:upload:Alice:Team Lead',
    );
  });
}
