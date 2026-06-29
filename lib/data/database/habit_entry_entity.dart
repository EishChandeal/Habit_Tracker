import 'package:objectbox/objectbox.dart';
import 'package:habit_tracker/data/models/dtos/dtos.dart';
import 'habit_entity.dart';

@Entity()
class HabitEntryEntity {
  @Id()
  int obId;

  @Unique()
  @Index()
  String id;

  @Index()
  String habitId;

  int date;
  double value;
  String? note;
  int createdAt;

  final ToOne<HabitEntity> habitEntity = ToOne<HabitEntity>();

  HabitEntryEntity({
    this.obId = 0,
    required this.id,
    required this.habitId,
    required this.date,
    required this.value,
    this.note,
    required this.createdAt,
  });

  factory HabitEntryEntity.fromDto(HabitEntryDto dto) {
    return HabitEntryEntity(
      id: dto.id,
      habitId: dto.habitId,
      date: dto.date.millisecondsSinceEpoch,
      value: dto.value,
      note: dto.note,
      createdAt: dto.createdAt.millisecondsSinceEpoch,
    );
  }

  HabitEntryDto toDto() {
    return HabitEntryDto(
      id: id,
      habitId: habitId,
      date: DateTime.fromMillisecondsSinceEpoch(date, isUtc: true),
      value: value,
      note: note,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt, isUtc: true),
    );
  }
}
