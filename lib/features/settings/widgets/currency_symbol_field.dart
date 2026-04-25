import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/app_localizations.dart';

class CurrencySymbolField extends StatelessWidget {
  const CurrencySymbolField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: l10n.currencySymbolLabel,
        hintText: r'$',
        border: OutlineInputBorder(),
        labelStyle: TextStyle(fontSize: 16),
      ),
      maxLength: 3,
      inputFormatters: [LengthLimitingTextInputFormatter(3)],
      validator: (v) {
        if (v == null || v.trim().isEmpty) {
          return l10n.currencySymbolValidationMessage;
        }
        return null;
      },
      onChanged: (v) {
        if (v.trim().isNotEmpty) onChanged(v.trim());
      },
    );
  }
}
