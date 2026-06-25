import 'dart:core';

class HabitLimitDto {
  final String id;
  final String habitId;
  final double? minValue;
  final double? maxValue;
  final DateTime effectiveFrom;
  final DateTime? effectiveTo;

  const HabitLimitDto({
    required this.id,
    required this.habitId,
    this.minValue,
    this.maxValue,
    required this.effectiveFrom,
    this.effectiveTo,
  });

  static const Object _sentinel = Object();

  HabitLimitDto copyWith({
    String? id,
    String? habitId,
    Object? minValue = _sentinel,
    Object? maxValue = _sentinel,
    DateTime? effectiveFrom,
    Object? effectiveTo = _sentinel,
  }) {
    return HabitLimitDto(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      minValue: minValue == _sentinel ? this.minValue : minValue as double?,
      maxValue: maxValue == _sentinel ? this.maxValue : maxValue as double?,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      effectiveTo: effectiveTo == _sentinel ? this.effectiveTo : effectiveTo as DateTime?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habitId': habitId,
      'minValue': minValue,
      'maxValue': maxValue,
      'effectiveFrom': effectiveFrom.toIso8601String(),
      'effectiveTo': effectiveTo?.toIso8601String(),
    };
  }

  factory HabitLimitDto.fromJson(Map<String, dynamic> json) {
    return HabitLimitDto(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      minValue: (json['minValue'] as num?)?.toDouble(),
      maxValue: (json['maxValue'] as num?)?.toDouble(),
      effectiveFrom: DateTime.parse(json['effectiveFrom'] as String),
      effectiveTo: json['effectiveTo'] != null
          ? DateTime.parse(json['effectiveTo'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitLimitDto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          habitId == other.habitId &&
          minValue == other.minValue &&
          maxValue == other.maxValue &&
          effectiveFrom == other.effectiveFrom &&
          effectiveTo == other.effectiveTo;

  @override
  int get hashCode =>
      id.hashCode ^
      habitId.hashCode ^
      minValue.hashCode ^
      maxValue.hashCode ^
      effectiveFrom.hashCode ^
      effectiveTo.hashCode;

  @override
  String toString() {
    return 'HabitLimitDto(id: $id, habitId: $habitId, minValue: $minValue, maxValue: $maxValue, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo)';
  }
}
