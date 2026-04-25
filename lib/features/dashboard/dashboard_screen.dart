import 'package:flutter/material.dart';
import 'package:work_track/l10n/app_localizations.dart';
import '../settings/settings_dialog.dart';
import 'widgets/forecast_header.dart';
import 'widgets/month_navigator.dart';
import 'widgets/calendar_grid.dart';
import 'widgets/day_editor_panel.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/icon/icon.png', width: 48, height: 48),
            const SizedBox(width: 10),
            Text(l10n.dashboardTitle),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l10n.settingsDialogTitle,
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => const SettingsDialog(),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ForecastHeader(),
          MonthNavigator(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 2, child: CalendarGrid()),
                Container(
                  constraints: BoxConstraints(minWidth: 330),
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: DayEditorPanel(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
