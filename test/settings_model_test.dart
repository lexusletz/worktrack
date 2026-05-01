import 'package:flutter_test/flutter_test.dart';
import 'package:work_track/core/settings/settings_model.dart';
import 'package:work_track/core/theme/typography.dart';

void main() {
  group('Settings', () {
    test('round-trips through JSON', () {
      const original = Settings(
        hourlyRate: 37.5,
        workingDays: {DateTime.monday, DateTime.wednesday, DateTime.friday},
        standardHoursPerDay: 7.5,
        currencySymbol: '€',
        fontFamily: FontFamilyOptions.FREDOKA,
      );

      final roundTripped = Settings.fromJsonString(original.toJsonString());
      expect(roundTripped, equals(original));
    });

    test('defaults round-trip through JSON', () {
      final roundTripped = Settings.fromJsonString(
        Settings.defaults.toJsonString(),
      );
      expect(roundTripped, equals(Settings.defaults));
    });

    test('copyWith overrides only specified fields', () {
      const base = Settings.defaults;
      final copy = base.copyWith(hourlyRate: 50, currencySymbol: '£');
      expect(copy.hourlyRate, 50);
      expect(copy.currencySymbol, '£');
      expect(copy.workingDays, base.workingDays);
      expect(copy.standardHoursPerDay, base.standardHoursPerDay);
    });
  });
}
