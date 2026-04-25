import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/forecast/forecast_providers.dart';
import '../../../core/settings/settings_providers.dart';
import '../../../core/worklog/worklog_model.dart';
import '../../../core/worklog/worklog_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../state/dashboard_providers.dart';
import 'day_cell.dart';

class CalendarGrid extends ConsumerWidget {
  const CalendarGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browsedMonth = ref.watch(browsedMonthProvider);
    final selectedDay = ref.watch(selectedDayProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final logsAsync = ref.watch(worklogsForMonthProvider(browsedMonth));
    final now = ref.read(nowProvider);
    final today = DateTime(now.year, now.month, now.day);

    final l10n = AppLocalizations.of(context)!;
    final weekdayHeaders = [
      l10n.monShort,
      l10n.tueShort,
      l10n.wedShort,
      l10n.thuShort,
      l10n.friShort,
      l10n.satShort,
      l10n.sunShort,
    ];

    final settings = settingsAsync.value;
    final logMap = <String, WorkLog>{
      for (final l in logsAsync.value ?? []) l.key: l,
    };

    final daysInMonth = DateUtils.getDaysInMonth(
      browsedMonth.year,
      browsedMonth.month,
    );
    final firstWeekday = DateTime(
      browsedMonth.year,
      browsedMonth.month,
      1,
    ).weekday;
    final leadingBlanks = firstWeekday - 1;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: weekdayHeaders
                .map(
                  (h) => Expanded(
                    child: Center(
                      child: Text(
                        h,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: GridView.builder(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
                mainAxisExtent: 180,
              ),
              itemCount: leadingBlanks + daysInMonth,
              itemBuilder: (_, i) {
                if (i < leadingBlanks) return const SizedBox.shrink();
                final dayNum = i - leadingBlanks + 1;
                final date = DateTime(
                  browsedMonth.year,
                  browsedMonth.month,
                  dayNum,
                );
                final log = logMap[WorkLog.keyFor(date)];
                final status = settings != null
                    ? dayStatusFor(date, log, settings)
                    : DayStatus.nonWorkday;
                final isSelected =
                    selectedDay != null &&
                    selectedDay.year == date.year &&
                    selectedDay.month == date.month &&
                    selectedDay.day == date.day;
                final isToday = date == today;

                return DayCell(
                  day: dayNum,
                  status: status,
                  isSelected: isSelected,
                  isToday: isToday,
                  hoursWorked: log?.hoursWorked,
                  onTap: () =>
                      ref.read(selectedDayProvider.notifier).state = date,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
