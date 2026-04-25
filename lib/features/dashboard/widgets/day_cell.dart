import 'package:flutter/material.dart';
import '../../../core/worklog/worklog_model.dart';

class DayCell extends StatelessWidget {
  const DayCell({
    super.key,
    required this.day,
    required this.status,
    required this.isSelected,
    required this.isToday,
    required this.hoursWorked,
    required this.onTap,
  });

  final int day;
  final DayStatus status;
  final bool isSelected;
  final bool isToday;
  final double? hoursWorked;
  final VoidCallback onTap;

  static const _statusColors = {
    DayStatus.pending: Color(0xFFBDBDBD),
    DayStatus.completed: Color(0xFF66BB6A),
    DayStatus.missed: Color(0xFFEF5350),
    DayStatus.extra: Color(0xFF5C6BC0),
    DayStatus.nonWorkday: Colors.transparent,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dotColor = _statusColors[status]!;
    final isNonWorkday = status == DayStatus.nonWorkday;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : isToday
              ? Border.all(
                  color: theme.colorScheme.primary.withAlpha(100),
                  width: 1,
                )
              : null,
          color: isSelected
              ? theme.colorScheme.primaryContainer.withAlpha(80)
              : _statusColors[status]?.withAlpha(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '$day',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isNonWorkday
                          ? theme.colorScheme.onSurface.withAlpha(80)
                          : null,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  if (!isNonWorkday)
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              if (hoursWorked != null)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '${hoursWorked!.toStringAsFixed(hoursWorked! % 1 == 0 ? 0 : 1)}h',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isNonWorkday
                          ? theme.colorScheme.onSurface.withAlpha(80)
                          : dotColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
