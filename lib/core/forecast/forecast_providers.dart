import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/dashboard/state/dashboard_providers.dart';
import '../settings/settings_providers.dart';
import '../worklog/worklog_providers.dart';
import 'forecast_engine.dart';
import 'forecast_model.dart';

final nowProvider = Provider<DateTime>((_) => DateTime.now());

final forecastProvider = Provider<AsyncValue<Forecast>>((ref) {
  final settingsAsync = ref.watch(settingsProvider);
  final today = ref.watch(nowProvider);
  final browsedMonth = ref.watch(browsedMonthProvider);
  final logsAsync = ref.watch(worklogsForMonthProvider(browsedMonth));

  return settingsAsync.when(
    loading: () => const AsyncLoading(),
    error: (e, st) => AsyncError(e, st),
    data: (settings) => logsAsync.when(
      loading: () => const AsyncLoading(),
      error: (e, st) => AsyncError(e, st),
      data: (logs) => AsyncData(
        ForecastEngine.compute(
          settings: settings,
          monthLogs: logs,
          today: today,
          month: browsedMonth,
        ),
      ),
    ),
  );
});
