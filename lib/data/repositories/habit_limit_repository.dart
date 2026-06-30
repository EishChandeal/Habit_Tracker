import 'package:uuid/uuid.dart';
import 'package:habit_tracker/data/models/dtos/dtos.dart';
import 'package:habit_tracker/data/database/habit_entity.dart';
import 'package:habit_tracker/data/database/habit_limit_entity.dart';
import 'package:habit_tracker/objectbox.g.dart';

class HabitLimitRepository {
  final Store _store;
  late final Box<HabitLimitEntity> _box;

  HabitLimitRepository(this._store) {
    _box = _store.box<HabitLimitEntity>();
  }

  Future<HabitLimitDto> setLimit({
    required String habitId,
    double? minValue,
    double? maxValue,
    required DateTime effectiveFrom,
  }) async {
    // Find any existing limit where habitId matches and effectiveTo is null
    final query = _box.query(HabitLimitEntity_.habitId.equals(habitId)).build();
    final activeLimits = query.find().where((e) => e.effectiveTo == null).toList();
    query.close();

    // Set its effectiveTo to DateTime.now().toUtc()
    final nowMillis = DateTime.now().toUtc().millisecondsSinceEpoch;
    for (final limit in activeLimits) {
      limit.effectiveTo = nowMillis;
      _box.put(limit);
    }

    // Find corresponding HabitEntity to set ToOne relation
    final habitBox = _store.box<HabitEntity>();
    final habitQuery = habitBox.query(HabitEntity_.id.equals(habitId)).build();
    final habit = habitQuery.findFirst();
    habitQuery.close();
    if (habit == null) {
      throw StateError('Habit not found with id: $habitId');
    }

    // Create a new limit entity with UUID and effectiveTo null
    final newLimit = HabitLimitEntity(
      id: const Uuid().v4(),
      habitId: habitId,
      minValue: minValue,
      maxValue: maxValue,
      effectiveFrom: effectiveFrom.millisecondsSinceEpoch,
      effectiveTo: null,
    );
    newLimit.habitEntity.target = habit;
    _box.put(newLimit);

    return newLimit.toDto();
  }

  Future<HabitLimitDto?> getActiveLimitForHabit(String habitId) async {
    final query = _box.query(HabitLimitEntity_.habitId.equals(habitId)).build();
    final results = query.find();
    query.close();

    final activeList = results.where((e) => e.effectiveTo == null).toList();
    if (activeList.isEmpty) return null;
    return activeList.first.toDto();
  }

  Future<List<HabitLimitDto>> getLimitHistoryForHabit(String habitId) async {
    final query = _box.query(HabitLimitEntity_.habitId.equals(habitId)).build();
    final results = query.find();
    query.close();

    // Sort by effectiveFrom descending
    results.sort((a, b) => b.effectiveFrom.compareTo(a.effectiveFrom));
    return results.map((e) => e.toDto()).toList();
  }
}
