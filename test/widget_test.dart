import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/main.dart';

void main() {
  testWidgets('HabitTrackerApp smoke test renders backend ready screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: HabitTrackerApp(),
      ),
    );

    expect(find.text('Habit Tracker Backend Ready'), findsOneWidget);
  });
}
