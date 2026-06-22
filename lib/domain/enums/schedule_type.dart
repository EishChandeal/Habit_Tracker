enum ScheduleType {
  daily,
  specificWeekdays,
  timesPerWeek,
  timesPerMonth;

  String get displayName {
    switch (this) {
      case ScheduleType.daily:
        return 'Daily';
      case ScheduleType.specificWeekdays:
        return 'Specific weekdays';
      case ScheduleType.timesPerWeek:
        return 'Times per week';
      case ScheduleType.timesPerMonth:
        return 'Times per month';
    }
  }

  static ScheduleType fromString(String value) {
    final lowerValue = value.toLowerCase();
    for (final type in ScheduleType.values) {
      if (type.name.toLowerCase() == lowerValue) {
        return type;
      }
    }
    throw ArgumentError('Invalid ScheduleType value: $value');
  }
}
