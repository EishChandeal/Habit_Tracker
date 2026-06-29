import 'package:objectbox/objectbox.dart';
import 'package:habit_tracker/data/models/dtos/dtos.dart';
import 'habit_entity.dart';

@Entity()
class HabitLimitEntity {
  @Id()
  int obId;

  @Unique()
  @Index()
  String id;

  @Index()
  String habitId;

  double? minValue;
  double? maxValue;
  int effectiveFrom;
  int? effectiveTo;

  final ToOne<HabitEntity> habitEntity = ToOne<HabitEntity>();

  HabitLimitEntity({
    this.obId = 0,
    required this.id,
    required this.habitId,
    this.minValue,
    this.maxValue,
    required this.effectiveFrom,
    this.effectiveTo,
  });

  factory HabitLimitEntity.fromDto(HabitLimitDto dto) {
    return HabitLimitEntity(
      id: dto.id,
      habitId: dto.habitId,
      minValue: dto.minValue,
      maxValue: dto.maxValue,
      effectiveFrom: dto.effectiveFrom.millisecondsSinceEpoch,
      effectiveTo: dto.effectiveTo?.millisecondsSinceEpoch,
    );
  }

  HabitLimitDto toDto() {
    return HabitLimitDto(
      id: id,
      habitId: habitId,
      minValue: minValue,
      maxValue: maxValue,
      effectiveFrom: DateTime.fromMillisecondsSinceEpoch(effectiveFrom, isUtc: true),
      effectiveTo: effectiveTo != null
          ? DateTime.fromMillisecondsSinceEpoch(effectiveTo!, isUtc: true)
          : null,
    );
  }
}
