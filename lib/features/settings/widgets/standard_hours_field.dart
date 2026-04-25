import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/app_localizations.dart';

class StandardHoursField extends StatelessWidget {
  const StandardHoursField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TextFormField(
      initialValue: value.toString(),
      decoration: InputDecoration(
        labelText: l10n.standardHoursLabel,
        suffixText: l10n.hoursAbbreviation,
        border: OutlineInputBorder(),
        labelStyle: TextStyle(fontSize: 16),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      validator: (v) {
        final n = double.tryParse(v ?? '');
        if (n == null || n <= 0 || n > 24) {
          return l10n.hoursValidationMessage;
        }
        return null;
      },
      onChanged: (v) {
        final n = double.tryParse(v);
        if (n != null && n > 0 && n <= 24) onChanged(n);
      },
    );
  }
}
