import 'package:uuid/uuid.dart';
import 'package:habit_tracker/data/models/dtos/dtos.dart';
import 'package:habit_tracker/domain/enums/enums.dart';
import 'package:habit_tracker/data/database/habit_entity.dart';
import 'package:habit_tracker/objectbox.g.dart';
import 'habit_schedule_repository.dart';

class HabitRepository {
  final Store _store;
  final HabitScheduleRepository _scheduleRepository;
  late final Box<HabitEntity> _box;

  HabitRepository(this._store, this._scheduleRepository) {
    _box = _store.box<HabitEntity>();
  }

  Future<HabitDto> createHabit({
    required String name,
    required HabitType type,
    String? unit,
    double? targetValue,
    required String colorHex,
    required String iconName,
    required ScheduleType scheduleType,
    List<Weekday>? scheduledWeekdays,
    int? targetCount,
  }) async {
    final id = const Uuid().v4();
    final createdAt = DateTime.now().toUtc();

    final dto = HabitDto(
      id: id,
      name: name,
      type: type,
      unit: unit,
      targetValue: targetValue,
      colorHex: colorHex,
      iconName: iconName,
      createdAt: createdAt,
      isArchived: false,
    );

    final entity = HabitEntity.fromDto(dto);
    _box.put(entity);

    // Add schedule covering its lifetime
    await _scheduleRepository.setSchedule(
      habitId: id,
      scheduleType: scheduleType,
      scheduledWeekdays: scheduledWeekdays,
      targetCount: targetCount,
      effectiveFrom: createdAt,
    );

    return dto;
  }

  Future<HabitDto> updateHabit(HabitDto updated) async {
    final query = _box.query(HabitEntity_.id.equals(updated.id)).build();
    final entity = query.findFirst();
    query.close();

    if (entity == null) {
      throw StateError('Habit not found with id: ${updated.id}');
    }

    // Update all mutable fields
    entity.name = updated.name;
    entity.type = updated.type.name;
    entity.unit = updated.unit;
    entity.targetValue = updated.targetValue;
    entity.colorHex = updated.colorHex;
    entity.iconName = updated.iconName;
    entity.isArchived = updated.isArchived;

    _box.put(entity);

    return updated;
  }

  Future<void> archiveHabit(String id) async {
    final query = _box.query(HabitEntity_.id.equals(id)).build();
    final entity = query.findFirst();
    query.close();

    if (entity == null) {
      throw StateError('Habit not found with id: $id');
    }

    entity.isArchived = true;
    _box.put(entity);
  }

  Stream<List<HabitDto>> watchAllHabits() {
    return _box
        .query(HabitEntity_.isArchived.equals(false))
        .watch(triggerImmediately: true)
        .map((query) => query.find().map((e) => e.toDto()).toList());
  }

  Future<HabitDto?> getHabitById(String id) async {
    final query = _box.query(HabitEntity_.id.equals(id)).build();
    final entity = query.findFirst();
    query.close();

    return entity?.toDto();
  }
}
