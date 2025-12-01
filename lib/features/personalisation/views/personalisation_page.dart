import 'package:flutter/material.dart';
import 'package:union_shop/core/widgets/base_scaffold.dart';
import 'package:union_shop/core/widgets/footer.dart';
import 'package:union_shop/core/widgets/header.dart';
import 'package:union_shop/features/personalisation/services/personalisation_service.dart';

class PersonalisationPage extends StatefulWidget {
  const PersonalisationPage({Key? key}) : super(key: key);

  @override
  State<PersonalisationPage> createState() => _PersonalisationPageState();
}

class _PersonalisationPageState extends State<PersonalisationPage> {
  final _service = PersonalisationService();
  final _lineControllers =
      List.generate(4, (_) => TextEditingController(), growable: false);
  final _formKey = GlobalKey<FormState>();
  PersonalisationOption _selectedOption = PersonalisationService.options.first;
  bool _includeUpload = false;
  int _qty = 1;

  @override
  void dispose() {
    for (final controller in _lineControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<TextEditingController> get _activeLineControllers =>
      _lineControllers.take(_selectedOption.textLines).toList();

  PersonalisationSelection _currentSelection({int? qty}) =>
      PersonalisationSelection(
        option: _selectedOption,
        includeUpload: _includeUpload,
        lines: _currentLines(),
        qty: qty ?? _qty,
      );

  double get _optionPrice => _service.optionPrice(
        _selectedOption,
        includeUpload: _includeUpload,
      );

  double get _totalPrice => _optionPrice * _qty;

  List<String> _currentLines() =>
      _activeLineControllers.map((c) => c.text.trim()).toList();

  String _priceBreakdown() => _service.priceBreakdown(
        _selectedOption,
        includeUpload: _includeUpload,
      );

  void _onOptionChanged(String optionId) {
    final option =
        PersonalisationService.options.firstWhere((it) => it.id == optionId);
    setState(() {
      _selectedOption = option;
      _includeUpload = option.supportsUpload;
    });
  }

  bool _validateSelection() {
    final formValid = _formKey.currentState?.validate() ?? false;
    if (!formValid) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please complete the highlighted fields.'),
        duration: Duration(seconds: 2),
      ));
      return false;
    }
    final validation = _service.validateSelection(_currentSelection());
    if (!validation.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(validation.message ?? 'Please check your selection.'),
        duration: const Duration(seconds: 2),
      ));
      return false;
    }
    return formValid;
  }

  void _addToCart() {
    if (!_validateSelection()) return;

    final result = _service.addToCart(_currentSelection());
    if (!result.success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.message),
        duration: const Duration(seconds: 2),
      ));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result.message),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      header: Header(
          onLogoTap: () => Navigator.pop(context), onPlaceholderPressed: () {}),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personalisation',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              // Personalised image preview
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Image.asset(
                    'Assets/personalised_image.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.broken_image,
                            size: 48, color: Colors.grey)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '£${_optionPrice.toStringAsFixed(2)} tax included',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 6),
              Text(
                _priceBreakdown(),
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const SizedBox(height: 18),

              // Per line block
              const Text('Per Line',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    _selectedOption.helper,
                    style: const TextStyle(color: Colors.black54),
                  )),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 240,
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedOption.id,
                      items: PersonalisationService.options
                          .map((option) => DropdownMenuItem(
                                value: option.id,
                                child: Text(option.label),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) _onOptionChanged(v);
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        helperText:
                            'Options change required fields and pricing automatically.',
                      ),
                    ),
                  ),
                ],
              ),

              if (_selectedOption.textLines > 0) ...[
                const SizedBox(height: 12),
                const Text('Personalisation Text',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ...List.generate(_selectedOption.textLines, (index) {
                  final label = 'Line ${index + 1}';
                  final suffix = index == 0
                      ? 'Included'
                      : '+£${_selectedOption.extraLineCost.toStringAsFixed(2)}';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextFormField(
                      controller: _lineControllers[index],
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Enter $label',
                        helperText:
                            '$label required for this option ($suffix).',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '$label is required for ${_selectedOption.label.toLowerCase()}';
                        }
                        return null;
                      },
                    ),
                  );
                }),
              ],

              if (_selectedOption.supportsUpload) ...[
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('I will upload my artwork'),
                  value: _includeUpload,
                  onChanged: (value) => setState(() => _includeUpload = value),
                  subtitle: Text(
                      'Required for logo options. Adds £${_selectedOption.uploadSurcharge.toStringAsFixed(2)} to cover setup.'),
                ),
              ],

              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Quantity',
                      style: TextStyle(fontWeight: FontWeight.w600)),
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
                        Builder(builder: (context) {
                          final remaining = _service
                              .remainingQtyForSelection(_currentSelection());
                          final canIncrement =
                              remaining > 0 && _qty < remaining;
                          return IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: canIncrement
                                ? () {
                                    setState(() => _qty++);
                                  }
                                : null,
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total: £${_totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Text(
                        'Price updates as you change options.',
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                      onPressed: _addToCart, child: const Text('ADD TO CART')),
                ],
              ),
            ],
          ),
        ),
      ),
      footer: const Footer(),
    );
  }
}
