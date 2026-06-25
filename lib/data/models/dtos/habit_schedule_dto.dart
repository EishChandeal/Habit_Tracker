import 'dart:core';
import '../../../domain/enums/enums.dart';

bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

class HabitScheduleDto {
  final String id;
  final String habitId;
  final ScheduleType scheduleType;
  final List<Weekday>? scheduledWeekdays;
  final int? targetCount;
  final DateTime effectiveFrom;
  final DateTime? effectiveTo;

  const HabitScheduleDto({
    required this.id,
    required this.habitId,
    required this.scheduleType,
    this.scheduledWeekdays,
    this.targetCount,
    required this.effectiveFrom,
    this.effectiveTo,
  });

  static const Object _sentinel = Object();

  HabitScheduleDto copyWith({
    String? id,
    String? habitId,
    ScheduleType? scheduleType,
    Object? scheduledWeekdays = _sentinel,
    Object? targetCount = _sentinel,
    DateTime? effectiveFrom,
    Object? effectiveTo = _sentinel,
  }) {
    return HabitScheduleDto(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      scheduleType: scheduleType ?? this.scheduleType,
      scheduledWeekdays: scheduledWeekdays == _sentinel
          ? this.scheduledWeekdays
          : scheduledWeekdays as List<Weekday>?,
      targetCount: targetCount == _sentinel ? this.targetCount : targetCount as int?,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      effectiveTo: effectiveTo == _sentinel ? this.effectiveTo : effectiveTo as DateTime?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habitId': habitId,
      'scheduleType': scheduleType.name,
      'scheduledWeekdays': scheduledWeekdays?.map((e) => e.name).toList(),
      'targetCount': targetCount,
      'effectiveFrom': effectiveFrom.toIso8601String(),
      'effectiveTo': effectiveTo?.toIso8601String(),
    };
  }

  factory HabitScheduleDto.fromJson(Map<String, dynamic> json) {
    return HabitScheduleDto(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      scheduleType: ScheduleType.fromString(json['scheduleType'] as String),
      scheduledWeekdays: json['scheduledWeekdays'] != null
          ? (json['scheduledWeekdays'] as List<dynamic>)
              .map((e) => Weekday.fromString(e as String))
              .toList()
          : null,
      targetCount: json['targetCount'] as int?,
      effectiveFrom: DateTime.parse(json['effectiveFrom'] as String),
      effectiveTo: json['effectiveTo'] != null
          ? DateTime.parse(json['effectiveTo'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitScheduleDto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          habitId == other.habitId &&
          scheduleType == other.scheduleType &&
          _listEquals(scheduledWeekdays, other.scheduledWeekdays) &&
          targetCount == other.targetCount &&
          effectiveFrom == other.effectiveFrom &&
          effectiveTo == other.effectiveTo;

  @override
  int get hashCode =>
      id.hashCode ^
      habitId.hashCode ^
      scheduleType.hashCode ^
      Object.hashAll(scheduledWeekdays ?? const []) ^
      targetCount.hashCode ^
      effectiveFrom.hashCode ^
      effectiveTo.hashCode;

  @override
  String toString() {
    return 'HabitScheduleDto(id: $id, habitId: $habitId, scheduleType: $scheduleType, scheduledWeekdays: $scheduledWeekdays, targetCount: $targetCount, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo)';
  }
}
