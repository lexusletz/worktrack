import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: emphasized ? theme.colorScheme.primaryContainer : null,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: emphasized
              ? Colors.transparent
              : theme.colorScheme.primaryContainer,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: emphasized
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: Text(
                value,
                style:
                    (emphasized
                            ? theme.textTheme.titleLarge
                            : theme.textTheme.titleMedium)
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: emphasized
                              ? theme.colorScheme.onPrimaryContainer
                              : null,
                          fontSize: 22,
                        ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
