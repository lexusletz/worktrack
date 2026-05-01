import 'package:flutter_test/flutter_test.dart';
import 'package:work_track/core/forecast/forecast_engine.dart';
import 'package:work_track/core/settings/settings_model.dart';
import 'package:work_track/core/theme/typography.dart';
import 'package:work_track/core/worklog/worklog_model.dart';

void main() {
  const settings = Settings(
    hourlyRate: 25,
    workingDays: {
      DateTime.monday,
      DateTime.tuesday,
      DateTime.wednesday,
      DateTime.thursday,
      DateTime.friday,
    },
    standardHoursPerDay: 8,
    currencySymbol: r'$',
    fontFamily: FontFamilyOptions.merriweather,
  );

  // Use April 2026 as test month (known structure)
  // April 1 = Wednesday. Working days: 22. Target = 22 * 8 * 25 = 4400

  int workdaysInApril2026() {
    int count = 0;
    for (
      var d = DateTime(2026, 4, 1);
      d.month == 4;
      d = d.add(const Duration(days: 1))
    ) {
      if (settings.workingDays.contains(d.weekday)) count++;
    }
    return count;
  }

  test('empty month — target correct, accumulated 0, remaining = target', () {
    final today = DateTime(2026, 4, 1);
    final f = ForecastEngine.compute(
      settings: settings,
      monthLogs: [],
      today: today,
      month: today,
    );

    final workdays = workdaysInApril2026();
    expect(f.target, workdays * 8 * 25);
    expect(f.accumulated, 0);
    // remaining = workdays after today (Apr 1 is today, so future = days 2–30)
    final futureWorkdays =
        workdays - 1; // day 1 is "today", no log → 0 accumulated
    expect(f.remaining, futureWorkdays * 8 * 25);
    expect(f.estimate, f.accumulated + f.remaining);
  });

  test('logged day at standard hours — accumulated reflects it', () {
    final today = DateTime(2026, 4, 2); // Thursday
    final logs = [
      WorkLog(date: DateTime(2026, 4, 1), hoursWorked: 8),
      WorkLog(date: DateTime(2026, 4, 2), hoursWorked: 8),
    ];
    final f = ForecastEngine.compute(
      settings: settings,
      monthLogs: logs,
      today: today,
      month: today,
    );
    expect(f.accumulated, 2 * 8 * 25);
  });

  test('past workday with no log contributes 0 (Pending rule)', () {
    final today = DateTime(2026, 4, 10); // Friday
    // Apr 1 (Wed) — no log, past → 0
    final f = ForecastEngine.compute(
      settings: settings,
      monthLogs: [],
      today: today,
      month: today,
    );
    expect(f.accumulated, 0);
  });

  test(
    'explicit 0h log on past workday → accumulated unchanged, status missed',
    () {
      final today = DateTime(2026, 4, 3);
      final logs = [WorkLog(date: DateTime(2026, 4, 1), hoursWorked: 0)];
      final f = ForecastEngine.compute(
        settings: settings,
        monthLogs: logs,
        today: today,
        month: today,
      );
      expect(f.accumulated, 0);
      final status = dayStatusFor(DateTime(2026, 4, 1), logs.first, settings);
      expect(status, DayStatus.missed);
    },
  );

  test('extra-day Saturday with 4h adds to accumulated, not target', () {
    final today = DateTime(2026, 4, 5); // Sunday (past)
    final logs = [
      WorkLog(
        date: DateTime(2026, 4, 4), // Saturday
        hoursWorked: 4,
        isExtraDay: true,
      ),
    ];
    final targetBefore = ForecastEngine.compute(
      settings: settings,
      monthLogs: [],
      today: today,
      month: today,
    ).target;
    final f = ForecastEngine.compute(
      settings: settings,
      monthLogs: logs,
      today: today,
      month: today,
    );
    expect(f.target, targetBefore); // target unchanged
    expect(f.accumulated, 4 * 25); // extra hours counted
  });

  test('future day with pre-logged hours uses logged hours in remaining', () {
    final today = DateTime(2026, 4, 1);
    final logs = [
      WorkLog(
        date: DateTime(2026, 4, 7),
        hoursWorked: 4,
      ), // future Monday, only 4h
    ];
    final fWithLog = ForecastEngine.compute(
      settings: settings,
      monthLogs: logs,
      today: today,
      month: today,
    );
    final fNoLog = ForecastEngine.compute(
      settings: settings,
      monthLogs: [],
      today: today,
      month: today,
    );
    // With 4h pre-log vs standard 8h → remaining should be less by 4 * rate
    expect(fWithLog.remaining, fNoLog.remaining - 4 * 25);
  });
}
