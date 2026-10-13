import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/presentation/theme/app_theme.dart';
import 'package:habit_tracker/presentation/widgets/habit_card.dart';
import 'package:habit_tracker/domain/models/habit_day_status.dart';
import 'package:habit_tracker/data/models/dtos/dtos.dart';
import 'package:habit_tracker/domain/enums/enums.dart';

void main() {
  testWidgets('HabitTrackerApp renders HomeScreen with dark theme and header controls',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: HabitTrackerApp(),
      ),
    );

    // Initial pump
    await tester.pump();

    // Verify today's date formatted is present in the header
    final formattedDate = DateFormat('d MMM').format(DateTime.now());
    expect(find.text(formattedDate), findsOneWidget);

    // Verify Add and Settings icons are present in the header
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

    // Verify dark theme values are active
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
    expect(scaffold.backgroundColor, AppColors.background);

    final theme = Theme.of(tester.element(find.byIcon(Icons.add)));
    expect(theme.scaffoldBackgroundColor, AppColors.background);
    expect(theme.colorScheme.primary, AppColors.blue);
    expect(theme.colorScheme.surface, AppColors.surface);
  });

  testWidgets('HabitCard renders boolean habit details and toggles completion',
      (WidgetTester tester) async {
    bool tappedCompletion = false;

    final habit = HabitDto(
      id: 'test-h1',
      name: 'Morning Jog',
      type: HabitType.boolean,
      colorHex: '#216CCF',
      iconName: 'directions_run',
      createdAt: DateTime.now().toUtc(),
      isArchived: false,
    );

    final item = HabitDayStatus(
      habit: habit,
      entry: null,
      isScheduledToday: true,
      status: DayStatus.missed,
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: HabitCard(
              item: item,
              onCompletionTap: () => tappedCompletion = true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Morning Jog'), findsOneWidget);
    expect(find.text('—'), findsOneWidget);

    // Tap completion control
    await tester.tap(find.text('—'));
    await tester.pump();
    expect(tappedCompletion, isTrue);
  });

  testWidgets('HabitCard renders numeric habit with logged value and unit',
      (WidgetTester tester) async {
    final habit = HabitDto(
      id: 'test-h2',
      name: 'Drink Water',
      type: HabitType.numeric,
      unit: 'ml',
      targetValue: 2000,
      colorHex: '#216CCF',
      iconName: 'water_drop',
      createdAt: DateTime.now().toUtc(),
      isArchived: false,
    );

    final entry = HabitEntryDto(
      id: 'entry-1',
      habitId: 'test-h2',
      date: DateTime.now().toUtc(),
      value: 1500,
      createdAt: DateTime.now().toUtc(),
    );

    final item = HabitDayStatus(
      habit: habit,
      entry: entry,
      isScheduledToday: true,
      status: DayStatus.partiallyMet,
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: HabitCard(
              item: item,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Drink Water'), findsOneWidget);
    expect(find.text('1500'), findsOneWidget);
    expect(find.text('ml'), findsWidgets);
  });
}
