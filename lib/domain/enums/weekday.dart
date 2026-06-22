enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  String get displayName {
    switch (this) {
      case Weekday.monday:
        return 'Monday';
      case Weekday.tuesday:
        return 'Tuesday';
      case Weekday.wednesday:
        return 'Wednesday';
      case Weekday.thursday:
        return 'Thursday';
      case Weekday.friday:
        return 'Friday';
      case Weekday.saturday:
        return 'Saturday';
      case Weekday.sunday:
        return 'Sunday';
    }
  }

  String get shortName {
    switch (this) {
      case Weekday.monday:
        return 'Mon';
      case Weekday.tuesday:
        return 'Tue';
      case Weekday.wednesday:
        return 'Wed';
      case Weekday.thursday:
        return 'Thu';
      case Weekday.friday:
        return 'Fri';
      case Weekday.saturday:
        return 'Sat';
      case Weekday.sunday:
        return 'Sun';
    }
  }

  static Weekday fromString(String value) {
    final lowerValue = value.toLowerCase();
    for (final weekday in Weekday.values) {
      if (weekday.name.toLowerCase() == lowerValue) {
        return weekday;
      }
    }
    throw ArgumentError('Invalid Weekday value: $value');
  }

  static Weekday fromDateTimeWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return Weekday.monday;
      case 2:
        return Weekday.tuesday;
      case 3:
        return Weekday.wednesday;
      case 4:
        return Weekday.thursday;
      case 5:
        return Weekday.friday;
      case 6:
        return Weekday.saturday;
      case 7:
        return Weekday.sunday;
      default:
        throw ArgumentError('Invalid DateTime weekday: $weekday. Must be between 1 and 7.');
    }
  }
}
