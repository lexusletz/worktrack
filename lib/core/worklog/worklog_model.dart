import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../settings/settings_model.dart';

enum DayStatus { PENDING, COMPLETED, MISSED, EXTRA, NONWORKDAY }

DayStatus dayStatusFor(DateTime day, WorkLog? log, Settings settings) {
  if (log == null) {
    return settings.workingDays.contains(day.weekday)
        ? DayStatus.PENDING
        : DayStatus.NONWORKDAY;
  }
  if (log.hoursWorked == 0) return DayStatus.MISSED;
  if (log.isExtraDay) return DayStatus.EXTRA;
  return DayStatus.COMPLETED;
}

@immutable
class WorkLog {
  const WorkLog({
    required this.date,
    required this.hoursWorked,
    this.isExtraDay = false,
    this.notes,
  });

  final DateTime date;
  final double hoursWorked;
  final bool isExtraDay;
  final String? notes;

  static String keyFor(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  String get key => keyFor(date);

  WorkLog copyWith({
    DateTime? date,
    double? hoursWorked,
    bool? isExtraDay,
    String? notes,
  }) {
    return WorkLog(
      date: date ?? this.date,
      hoursWorked: hoursWorked ?? this.hoursWorked,
      isExtraDay: isExtraDay ?? this.isExtraDay,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkLog &&
          date == other.date &&
          hoursWorked == other.hoursWorked &&
          isExtraDay == other.isExtraDay &&
          notes == other.notes;

  @override
  int get hashCode => Object.hash(date, hoursWorked, isExtraDay, notes);
}

class WorkLogAdapter extends TypeAdapter<WorkLog> {
  @override
  final int typeId = 0;

  @override
  WorkLog read(BinaryReader reader) {
    return WorkLog(
      date: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      hoursWorked: reader.readDouble(),
      isExtraDay: reader.readBool(),
      notes: reader.readBool() ? reader.readString() : null,
    );
  }

  @override
  void write(BinaryWriter writer, WorkLog obj) {
    writer.writeInt(obj.date.millisecondsSinceEpoch);
    writer.writeDouble(obj.hoursWorked);
    writer.writeBool(obj.isExtraDay);
    writer.writeBool(obj.notes != null);
    if (obj.notes != null) writer.writeString(obj.notes!);
  }
}
