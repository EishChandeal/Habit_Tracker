import 'dart:io';
import 'package:habit_tracker/objectbox.g.dart';
import 'package:habit_tracker/data/repositories/habit_repository.dart';
import 'package:habit_tracker/data/repositories/habit_entry_repository.dart';
import 'package:habit_tracker/data/repositories/habit_limit_repository.dart';
import 'package:habit_tracker/data/repositories/habit_schedule_repository.dart';
import 'package:habit_tracker/domain/services/streak_engine.dart';
import 'package:habit_tracker/domain/services/statistics_service.dart';
import 'package:habit_tracker/domain/enums/enums.dart';

void main() async {
  final tempDir = Directory.systemTemp.createTempSync('habit_dev_');
  print('Using temp dir: ${tempDir.path}');
  final store = await openStore(directory: tempDir.path);
  
  try {
    final scheduleRepo = HabitScheduleRepository(store);
    final habitRepo = HabitRepository(store, scheduleRepo);
    final entryRepo = HabitEntryRepository(store);
    final limitRepo = HabitLimitRepository(store);
    
    final meditation = await habitRepo.createHabit(
      name: 'Morning meditation',
      type: HabitType.boolean,
      colorHex: '#6C63FF',
      iconName: 'meditation',
      scheduleType: ScheduleType.daily,
    );
    
    final steps = await habitRepo.createHabit(
      name: 'Daily steps',
      type: HabitType.numeric,
      unit: 'steps',
      targetValue: 10000.0,
      colorHex: '#FF6584',
      iconName: 'footsteps',
      scheduleType: ScheduleType.daily,
    );
    
    final today = DateTime.now().toUtc();
    final todayMidnight = DateTime.utc(today.year, today.month, today.day);
    final stepsPattern = [7500, 11000, 9200, 13000, 6800, 10500, 8900];
    
    for (int i = 29; i >= 0; i--) {
      final date = todayMidnight.subtract(Duration(days: i));
      
      // Meditation
      if (i != 8 && i != 15 && i != 22) {
        await entryRepo.upsertEntry(
          habitId: meditation.id,
          date: date,
          value: 1.0,
        );
      }
      
      // Steps
      final stepsValue = stepsPattern[i % stepsPattern.length].toDouble();
      await entryRepo.upsertEntry(
        habitId: steps.id,
        date: date,
        value: stepsValue,
      );
    }
    
    await limitRepo.setLimit(
      habitId: steps.id,
      maxValue: 10000.0,
      effectiveFrom: todayMidnight.subtract(const Duration(days: 30)),
    );
    
    await limitRepo.setLimit(
      habitId: steps.id,
      maxValue: 12000.0,
      effectiveFrom: todayMidnight.subtract(const Duration(days: 15)),
    );
    
    final meditationEntries = await entryRepo.watchEntriesForHabit(meditation.id).first;
    final meditationSchedules = await scheduleRepo.getScheduleHistoryForHabit(meditation.id);
    
    final meditationStreak = StreakEngine.calculate(
      entries: meditationEntries,
      scheduleHistory: meditationSchedules,
    );
    print('\n--- Meditation Streak ---');
    print(meditationStreak);
    
    final stepsEntries = await entryRepo.watchEntriesForHabit(steps.id).first;
    final stepsSchedules = await scheduleRepo.getScheduleHistoryForHabit(steps.id);
    
    final stepsStreak = StreakEngine.calculate(
      entries: stepsEntries,
      scheduleHistory: stepsSchedules,
    );
    print('\n--- Steps Streak ---');
    print(stepsStreak);
    
    final activeLimit = await limitRepo.getActiveLimitForHabit(steps.id);
    final stepsStats = StatisticsService.calculate(
      entries: stepsEntries,
      activeLimit: activeLimit,
    );
    print('\n--- Steps Statistics ---');
    print(stepsStats);
    
    print('\n--- Meditation Heatmap (Last 14 days) ---');
    final buffer = StringBuffer();
    for (int i = 13; i >= 0; i--) {
      final date = todayMidnight.subtract(Duration(days: i));
      final status = meditationStreak.heatmap[date] ?? DayStatus.notTracked;
      if (status == DayStatus.met) {
        buffer.write('■ ');
      } else if (status == DayStatus.missed) {
        buffer.write('□ ');
      } else {
        buffer.write('· ');
      }
    }
    print(buffer.toString());
    
  } finally {
    store.close();
    tempDir.deleteSync(recursive: true);
    print('\nCleanup complete.');
  }
}
