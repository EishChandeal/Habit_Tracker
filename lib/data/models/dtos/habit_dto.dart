import 'dart:core';
import '../../../domain/enums/enums.dart';

class HabitDto {
  final String id;
  final String name;
  final HabitType type;
  final String? unit;
  final double? targetValue;
  final FrequencyType frequency;
  final String colorHex;
  final String iconName;
  final DateTime createdAt;
  final bool isArchived;

  const HabitDto({
    required this.id,
    required this.name,
    required this.type,
    this.unit,
    this.targetValue,
    required this.frequency,
    required this.colorHex,
    required this.iconName,
    required this.createdAt,
    required this.isArchived,
  });

  static const Object _sentinel = Object();

  HabitDto copyWith({
    String? id,
    String? name,
    HabitType? type,
    Object? unit = _sentinel,
    Object? targetValue = _sentinel,
    FrequencyType? frequency,
    String? colorHex,
    String? iconName,
    DateTime? createdAt,
    bool? isArchived,
  }) {
    return HabitDto(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      unit: unit == _sentinel ? this.unit : unit as String?,
      targetValue: targetValue == _sentinel ? this.targetValue : targetValue as double?,
      frequency: frequency ?? this.frequency,
      colorHex: colorHex ?? this.colorHex,
      iconName: iconName ?? this.iconName,
      createdAt: createdAt ?? this.createdAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'unit': unit,
      'targetValue': targetValue,
      'frequency': frequency.name,
      'colorHex': colorHex,
      'iconName': iconName,
      'createdAt': createdAt.toIso8601String(),
      'isArchived': isArchived,
    };
  }

  factory HabitDto.fromJson(Map<String, dynamic> json) {
    return HabitDto(
      id: json['id'] as String,
      name: json['name'] as String,
      type: HabitType.fromString(json['type'] as String),
      unit: json['unit'] as String?,
      targetValue: (json['targetValue'] as num?)?.toDouble(),
      frequency: FrequencyType.fromString(json['frequency'] as String),
      colorHex: json['colorHex'] as String,
      iconName: json['iconName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isArchived: json['isArchived'] as bool,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitDto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          type == other.type &&
          unit == other.unit &&
          targetValue == other.targetValue &&
          frequency == other.frequency &&
          colorHex == other.colorHex &&
          iconName == other.iconName &&
          createdAt == other.createdAt &&
          isArchived == other.isArchived;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      type.hashCode ^
      unit.hashCode ^
      targetValue.hashCode ^
      frequency.hashCode ^
      colorHex.hashCode ^
      iconName.hashCode ^
      createdAt.hashCode ^
      isArchived.hashCode;

  @override
  String toString() {
    return 'HabitDto(id: $id, name: $name, type: $type, unit: $unit, targetValue: $targetValue, frequency: $frequency, colorHex: $colorHex, iconName: $iconName, createdAt: $createdAt, isArchived: $isArchived)';
  }
}
