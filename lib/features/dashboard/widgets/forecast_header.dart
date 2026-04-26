import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:work_track/l10n/app_localizations.dart';
import '../../../core/forecast/forecast_providers.dart';
import '../../../core/settings/settings_providers.dart';
import 'stat_card.dart';

class ForecastHeader extends ConsumerWidget {
  const ForecastHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastAsync = ref.watch(forecastProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final symbol = settingsAsync.value?.currencySymbol ?? r'$';

    String fmt(double v) =>
        NumberFormat.currency(symbol: symbol, decimalDigits: 2).format(v);

    return forecastAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: LinearProgressIndicator(),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Forecast error: $e'),
      ),
      data: (f) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final card1 = StatCard(
              label: AppLocalizations.of(context)!.accumulatedLabel,
              value: fmt(f.accumulated),
            );
            final card2 = StatCard(
              label: AppLocalizations.of(context)!.remainingLabel,
              value: fmt(f.remaining),
            );
            final card3 = StatCard(
              label: AppLocalizations.of(context)!.estimatedLabel,
              value: fmt(f.estimate),
              emphasized: true,
            );
            final card4 = StatCard(
              label: AppLocalizations.of(context)!.targetLabel,
              value: fmt(f.target),
            );

            if (constraints.maxWidth < 600) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: card1),
                      const SizedBox(width: 8),
                      Expanded(child: card2),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: card3),
                      const SizedBox(width: 8),
                      Expanded(child: card4),
                    ],
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: card1),
                const SizedBox(width: 8),
                Expanded(child: card2),
                const SizedBox(width: 8),
                Expanded(child: card3),
                const SizedBox(width: 8),
                Expanded(child: card4),
              ],
            );
          },
        ),
      ),
    );
  }
}
