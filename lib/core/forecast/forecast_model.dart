import 'package:flutter/foundation.dart';

@immutable
class Forecast {
  const Forecast({
    required this.accumulated,
    required this.remaining,
    required this.estimate,
    required this.target,
  });

  /// The total estimated earnings in the current month.
  final double accumulated;

  /// The total estimated earnings for the remaining work in the current month.
  final double remaining;

  /// The total estimated earnings in the current month.
  final double estimate;

  /// The total estimated earnings for the month if all work is completed.
  final double target;

  static const zero = Forecast(
    accumulated: 0,
    remaining: 0,
    estimate: 0,
    target: 0,
  );
}
