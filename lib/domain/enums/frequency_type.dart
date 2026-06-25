enum FrequencyType {
  daily,
  weekly,
  monthly;

  String get displayName {
    switch (this) {
      case FrequencyType.daily:
        return 'Daily';
      case FrequencyType.weekly:
        return 'Weekly';
      case FrequencyType.monthly:
        return 'Monthly';
    }
  }

  static FrequencyType fromString(String value) {
    final lowerValue = value.toLowerCase();
    for (final type in FrequencyType.values) {
      if (type.name.toLowerCase() == lowerValue) {
        return type;
      }
    }
    throw ArgumentError('Invalid FrequencyType value: $value');
  }
}
