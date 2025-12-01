import 'package:union_shop/features/cart/services/cart_service.dart';
import 'package:union_shop/features/products/models/product.dart';

class PersonalisationOption {
  final String id;
  final String label;
  final double basePrice;
  final int textLines;
  final double extraLineCost;
  final bool supportsUpload;
  final double uploadSurcharge;
  final String helper;

  const PersonalisationOption({
    required this.id,
    required this.label,
    required this.basePrice,
    required this.textLines,
    this.extraLineCost = 0,
    this.supportsUpload = false,
    this.uploadSurcharge = 0,
    this.helper = '',
  });
}

class PersonalisationSelection {
  final PersonalisationOption option;
  final bool includeUpload;
  final List<String> lines;
  final int qty;

  const PersonalisationSelection({
    required this.option,
    required this.includeUpload,
    required this.lines,
    this.qty = 1,
  });
}

class PersonalisationValidationResult {
  final bool isValid;
  final String? message;

  const PersonalisationValidationResult(this.isValid, [this.message]);
}

class AddToCartResult {
  final bool success;
  final String message;
  final int addedQty;

  const AddToCartResult({
    required this.success,
    required this.message,
    required this.addedQty,
  });
}

class PersonalisationService {
  PersonalisationService({CartService? cartService})
      : cartService = cartService ?? CartService.instance;

  final CartService cartService;

  static const List<PersonalisationOption> options = [
    PersonalisationOption(
      id: 'one-line',
      label: 'One Line of Text',
      basePrice: 3.0,
      textLines: 1,
      helper: 'One stitched line included.',
    ),
    PersonalisationOption(
      id: 'two-lines',
      label: 'Two Lines of Text',
      basePrice: 3.0,
      textLines: 2,
      extraLineCost: 1.25,
      helper: 'Adds a second line (+£1.25) for job titles or teams.',
    ),
    PersonalisationOption(
      id: 'three-lines',
      label: 'Three Lines of Text',
      basePrice: 3.0,
      textLines: 3,
      extraLineCost: 1.25,
      helper: 'Three stitched lines (+£1.25 per extra line).',
    ),
    PersonalisationOption(
      id: 'four-lines',
      label: 'Four Lines of Text',
      basePrice: 3.0,
      textLines: 4,
      extraLineCost: 1.25,
      helper: 'Maximum coverage (+£1.25 per extra line).',
    ),
    PersonalisationOption(
      id: 'small-logo',
      label: 'Small Logo (Chest)',
      basePrice: 5.0,
      textLines: 0,
      supportsUpload: true,
      uploadSurcharge: 2.0,
      helper:
          'Upload-ready artwork with a small stitch area (+£2 for upload prep).',
    ),
    PersonalisationOption(
      id: 'large-logo',
      label: 'Large Logo (Back)',
      basePrice: 7.0,
      textLines: 0,
      supportsUpload: true,
      uploadSurcharge: 3.0,
      helper: 'Best for high-impact branding (+£3 for upload prep).',
    ),
  ];

  double optionPrice(
    PersonalisationOption option, {
    required bool includeUpload,
  }) {
    final extraLineCount = option.textLines > 1 ? option.textLines - 1 : 0;
    final lineCost = extraLineCount * option.extraLineCost;
    final uploadCost =
        option.supportsUpload && includeUpload ? option.uploadSurcharge : 0;
    return option.basePrice + lineCost + uploadCost;
  }

  double totalPrice(PersonalisationSelection selection) =>
      optionPrice(selection.option, includeUpload: selection.includeUpload) *
      selection.qty;

  String priceBreakdown(
    PersonalisationOption option, {
    required bool includeUpload,
  }) {
    final parts = <String>['Base £${option.basePrice.toStringAsFixed(2)}'];
    if (option.textLines > 1 && option.extraLineCost > 0) {
      final count = option.textLines - 1;
      final total = count * option.extraLineCost;
      parts.add('$count extra line(s) +£${total.toStringAsFixed(2)}');
    }
    if (option.supportsUpload && includeUpload) {
      parts
          .add('Artwork upload +£${option.uploadSurcharge.toStringAsFixed(2)}');
    }
    return parts.join(' • ');
  }

  String productConfigKey(PersonalisationSelection selection) {
    final trimmedLines = _normalizedLines(selection);
    final parts = [
      selection.option.id,
      selection.includeUpload ? 'upload' : 'no-upload',
      ...trimmedLines.map(
        (line) => line.isEmpty ? '-' : line.replaceAll(':', '-'),
      ),
    ];
    return parts.join(':');
  }

  String productId(PersonalisationSelection selection) =>
      'personalisation-${productConfigKey(selection)}';

  String productDescription(PersonalisationSelection selection) {
    final trimmedLines =
        _normalizedLines(selection).where((line) => line.isNotEmpty).toList();
    return [
      'Option: ${selection.option.label}',
      'Upload: ${selection.includeUpload ? 'yes' : 'no'}',
      if (trimmedLines.isNotEmpty) 'Lines: ${trimmedLines.join(' / ')}',
    ].join(' • ');
  }

  PersonalisationValidationResult validateSelection(
      PersonalisationSelection selection) {
    if (selection.qty < 1) {
      return const PersonalisationValidationResult(
        false,
        'Select at least one item.',
      );
    }

    final lines = _normalizedLines(selection);
    for (var i = 0; i < selection.option.textLines; i++) {
      if (lines.length <= i || lines[i].isEmpty) {
        return PersonalisationValidationResult(
          false,
          'Line ${i + 1} is required for ${selection.option.label.toLowerCase()}',
        );
      }
    }

    if (selection.option.supportsUpload && !selection.includeUpload) {
      return const PersonalisationValidationResult(
        false,
        'Enable artwork upload to proceed with logo options.',
      );
    }

    return const PersonalisationValidationResult(true);
  }

  int remainingQtyForSelection(PersonalisationSelection selection) {
    final inCart = cartService.qtyFor(productId(selection));
    final remaining = CartService.maxPerItem - inCart;
    return remaining > 0 ? remaining : 0;
  }

  AddToCartResult addToCart(PersonalisationSelection selection) {
    final validation = validateSelection(selection);
    if (!validation.isValid) {
      return AddToCartResult(
        success: false,
        message: validation.message ?? 'Invalid selection.',
        addedQty: 0,
      );
    }

    final product = Product(
      id: productId(selection),
      name: 'Personalisation - ${selection.option.label}',
      price:
          optionPrice(selection.option, includeUpload: selection.includeUpload),
      description: productDescription(selection),
      categories: ['Personalisation'],
    );

    final allowed = remainingQtyForSelection(selection);
    if (allowed <= 0) {
      return const AddToCartResult(
        success: false,
        message:
            'You already have the maximum personalisation items in your cart.',
        addedQty: 0,
      );
    }

    final toAdd = selection.qty > allowed ? allowed : selection.qty;
    cartService.addItem(product, toAdd);

    final perItemPrice =
        optionPrice(selection.option, includeUpload: selection.includeUpload)
            .toStringAsFixed(2);

    final message = toAdd < selection.qty
        ? 'Added $toAdd to cart at £$perItemPrice each (max ${CartService.maxPerItem} per item).'
        : 'Added $toAdd to cart at £$perItemPrice each';

    return AddToCartResult(
      success: true,
      message: message,
      addedQty: toAdd,
    );
  }

  List<String> _normalizedLines(PersonalisationSelection selection) {
    final trimmed = selection.lines.map((line) => line.trim()).toList();
    if (trimmed.length < selection.option.textLines) {
      trimmed.addAll(
        List.filled(selection.option.textLines - trimmed.length, ''),
      );
    }
    return trimmed.take(selection.option.textLines).toList();
  }
}
