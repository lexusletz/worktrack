import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_track/features/settings/widgets/font_family_selector.dart';
import '../../core/settings/settings_model.dart';
import '../../core/settings/settings_providers.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/hourly_rate_field.dart';
import 'widgets/working_days_selector.dart';
import 'widgets/standard_hours_field.dart';
import 'widgets/currency_symbol_field.dart';

class SettingsDialog extends ConsumerStatefulWidget {
  const SettingsDialog({super.key});

  @override
  ConsumerState<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends ConsumerState<SettingsDialog> {
  final _formKey = GlobalKey<FormState>();
  late Settings _draft;

  @override
  void initState() {
    super.initState();
    _draft = ref.read(settingsProvider).value ?? Settings.defaults;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(settingsProvider.notifier).saveSettings(_draft);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.settingsDialogTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                HourlyRateField(
                  value: _draft.hourlyRate,
                  currencySymbol: _draft.currencySymbol,
                  onChanged: (v) => setState(() {
                    _draft = _draft.copyWith(hourlyRate: v);
                  }),
                ),
                const SizedBox(height: 16),
                WorkingDaysSelector(
                  selected: _draft.workingDays,
                  onChanged: (v) => setState(() {
                    _draft = _draft.copyWith(workingDays: v);
                  }),
                ),
                const SizedBox(height: 16),
                StandardHoursField(
                  value: _draft.standardHoursPerDay,
                  onChanged: (v) => setState(() {
                    _draft = _draft.copyWith(standardHoursPerDay: v);
                  }),
                ),
                const SizedBox(height: 16),
                CurrencySymbolField(
                  value: _draft.currencySymbol,
                  onChanged: (v) => setState(() {
                    _draft = _draft.copyWith(currencySymbol: v);
                  }),
                ),
                const SizedBox(height: 2),
                FontFamilySelector(
                  onChanged: (v) => setState(() {
                    _draft = _draft.copyWith(fontFamily: v);
                  }),
                  value: _draft.fontFamily,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.cancel, style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _save,
                      child: Text(l10n.save, style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
