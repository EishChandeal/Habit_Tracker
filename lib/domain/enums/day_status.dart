enum DayStatus {
  notTracked,
  notScheduled,
  missed,
  partiallyMet,
  met,
  exceeded;

  String get displayName {
    switch (this) {
      case DayStatus.notTracked:
        return 'Not tracked';
      case DayStatus.notScheduled:
        return 'Not scheduled';
      case DayStatus.missed:
        return 'Missed';
      case DayStatus.partiallyMet:
        return 'Partially met';
      case DayStatus.met:
        return 'Met';
      case DayStatus.exceeded:
        return 'Exceeded';
    }
  }

  static DayStatus fromString(String value) {
    final lowerValue = value.toLowerCase();
    for (final status in DayStatus.values) {
      if (status.name.toLowerCase() == lowerValue) {
        return status;
      }
    }
    throw ArgumentError('Invalid DayStatus value: $value');
  }
}
