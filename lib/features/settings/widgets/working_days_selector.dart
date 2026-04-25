import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class WorkingDaysSelector extends StatelessWidget {
  const WorkingDaysSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Set<int> selected;
  final ValueChanged<Set<int>> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = {
      DateTime.monday: l10n.monShort,
      DateTime.tuesday: l10n.tueShort,
      DateTime.wednesday: l10n.wedShort,
      DateTime.thursday: l10n.thuShort,
      DateTime.friday: l10n.friShort,
      DateTime.saturday: l10n.satShort,
      DateTime.sunday: l10n.sunShort,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.workingDaysLabel,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: labels.entries.map((e) {
            final isSelected = selected.contains(e.key);
            return FilterChip(
              label: Text(e.value),
              selected: isSelected,
              onSelected: (on) {
                final next = Set<int>.from(selected);
                if (on) {
                  next.add(e.key);
                } else if (next.length > 1) {
                  next.remove(e.key);
                }
                onChanged(next);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
