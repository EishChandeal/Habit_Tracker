import 'dart:core';

class HabitEntryDto {
  final String id;
  final String habitId;
  final DateTime date;
  final double value;
  final String? note;
  final DateTime createdAt;

  const HabitEntryDto({
    required this.id,
    required this.habitId,
    required this.date,
    required this.value,
    this.note,
    required this.createdAt,
  });

  static const Object _sentinel = Object();

  HabitEntryDto copyWith({
    String? id,
    String? habitId,
    DateTime? date,
    double? value,
    Object? note = _sentinel,
    DateTime? createdAt,
  }) {
    return HabitEntryDto(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      value: value ?? this.value,
      note: note == _sentinel ? this.note : note as String?,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habitId': habitId,
      'date': date.toIso8601String(),
      'value': value,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory HabitEntryDto.fromJson(Map<String, dynamic> json) {
    return HabitEntryDto(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      date: DateTime.parse(json['date'] as String),
      value: (json['value'] as num).toDouble(),
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitEntryDto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          habitId == other.habitId &&
          date == other.date &&
          value == other.value &&
          note == other.note &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      habitId.hashCode ^
      date.hashCode ^
      value.hashCode ^
      note.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'HabitEntryDto(id: $id, habitId: $habitId, date: $date, value: $value, note: $note, createdAt: $createdAt)';
  }
}
