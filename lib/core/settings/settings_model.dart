import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../theme/typography.dart';

@immutable
class Settings {
  const Settings({
    required this.hourlyRate,
    required this.workingDays,
    required this.standardHoursPerDay,
    required this.currencySymbol,
    required this.fontFamily,
  });

  final double hourlyRate;
  final Set<int> workingDays;
  final double standardHoursPerDay;
  final String currencySymbol;

  final FontFamilyOptions fontFamily;

  static const defaults = Settings(
    hourlyRate: 0,
    workingDays: {
      DateTime.monday,
      DateTime.tuesday,
      DateTime.wednesday,
      DateTime.thursday,
      DateTime.friday,
    },
    standardHoursPerDay: 8,
    currencySymbol: r'$',
    fontFamily: FontFamilyOptions.FREDOKA,
  );

  Settings copyWith({
    double? hourlyRate,
    Set<int>? workingDays,
    double? standardHoursPerDay,
    String? currencySymbol,
    FontFamilyOptions? fontFamily,
  }) {
    return Settings(
      hourlyRate: hourlyRate ?? this.hourlyRate,
      workingDays: workingDays ?? this.workingDays,
      standardHoursPerDay: standardHoursPerDay ?? this.standardHoursPerDay,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  Map<String, dynamic> toJson() => {
    'hourlyRate': hourlyRate,
    'workingDays': workingDays.toList(),
    'standardHoursPerDay': standardHoursPerDay,
    'currencySymbol': currencySymbol,
    'fontFamily': fontFamily.name,
  };

  factory Settings.fromJson(Map<String, dynamic> j) => Settings(
    hourlyRate: (j['hourlyRate'] as num).toDouble(),
    workingDays: Set<int>.from(j['workingDays'] as List),
    standardHoursPerDay: (j['standardHoursPerDay'] as num).toDouble(),
    currencySymbol: j['currencySymbol'] as String,
    fontFamily: FontFamilyOptions.values.firstWhere(
      (e) => e.name == j['fontFamily'],
      orElse: () => FontFamilyOptions.FREDOKA,
    ),
  );

  String toJsonString() => jsonEncode(toJson());
  factory Settings.fromJsonString(String s) =>
      Settings.fromJson(jsonDecode(s) as Map<String, dynamic>);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Settings &&
          hourlyRate == other.hourlyRate &&
          setEquals(workingDays, other.workingDays) &&
          standardHoursPerDay == other.standardHoursPerDay &&
          currencySymbol == other.currencySymbol &&
          fontFamily == other.fontFamily;

  @override
  int get hashCode => Object.hash(
    hourlyRate,
    Object.hashAll(workingDays.toList()..sort()),
    standardHoursPerDay,
    currencySymbol,
  );
}
