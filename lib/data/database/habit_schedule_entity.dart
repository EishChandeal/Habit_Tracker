import 'package:objectbox/objectbox.dart';
import 'package:habit_tracker/data/models/dtos/dtos.dart';
import 'package:habit_tracker/domain/enums/enums.dart';
import 'habit_entity.dart';

@Entity()
class HabitScheduleEntity {
  @Id()
  int obId;

  @Unique()
  @Index()
  String id;

  @Index()
  String habitId;

  String scheduleType;
  List<String>? scheduledWeekdays;
  int? targetCount;
  int effectiveFrom;
  int? effectiveTo;

  final ToOne<HabitEntity> habitEntity = ToOne<HabitEntity>();

  HabitScheduleEntity({
    this.obId = 0,
    required this.id,
    required this.habitId,
    required this.scheduleType,
    this.scheduledWeekdays,
    this.targetCount,
    required this.effectiveFrom,
    this.effectiveTo,
  });

  factory HabitScheduleEntity.fromDto(HabitScheduleDto dto) {
    return HabitScheduleEntity(
      id: dto.id,
      habitId: dto.habitId,
      scheduleType: dto.scheduleType.name,
      scheduledWeekdays: dto.scheduledWeekdays?.map((e) => e.name).toList(),
      targetCount: dto.targetCount,
      effectiveFrom: dto.effectiveFrom.millisecondsSinceEpoch,
      effectiveTo: dto.effectiveTo?.millisecondsSinceEpoch,
    );
  }

  HabitScheduleDto toDto() {
    return HabitScheduleDto(
      id: id,
      habitId: habitId,
      scheduleType: ScheduleType.fromString(scheduleType),
      scheduledWeekdays: scheduledWeekdays
          ?.map((e) => Weekday.fromString(e))
          .toList(),
      targetCount: targetCount,
      effectiveFrom: DateTime.fromMillisecondsSinceEpoch(effectiveFrom, isUtc: true),
      effectiveTo: effectiveTo != null
          ? DateTime.fromMillisecondsSinceEpoch(effectiveTo!, isUtc: true)
          : null,
    );
  }
}
