enum HabitType {
  boolean,
  numeric;

  String get displayName {
    switch (this) {
      case HabitType.boolean:
        return 'Yes / No';
      case HabitType.numeric:
        return 'Number';
    }
  }

  static HabitType fromString(String value) {
    final lowerValue = value.toLowerCase();
    for (final type in HabitType.values) {
      if (type.name.toLowerCase() == lowerValue) {
        return type;
      }
    }
    throw ArgumentError('Invalid HabitType value: $value');
  }
}
