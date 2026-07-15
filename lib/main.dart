import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:habit_tracker/data/database/app_database.dart';
import 'package:habit_tracker/application/providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final store = await AppDatabase.openStore(directory: dir.path);

  runApp(
    ProviderScope(
      overrides: [
        objectBoxStoreProvider.overrideWith((ref) {
          ref.onDispose(() => AppDatabase.closeStore());
          return Future.value(store);
        }),
      ],
      child: const HabitTrackerApp(),
    ),
  );
}

class HabitTrackerApp extends ConsumerWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Eagerly initialize DayChangeController so midnight & resume day-change events
    // are observed for the lifetime of the application.
    ref.watch(dayChangeControllerProvider);

    return MaterialApp(
      title: 'Habit Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 64,
                color: Color(0xFF6366F1),
              ),
              SizedBox(height: 16),
              Text(
                'Habit Tracker Backend Ready',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Riverpod providers, ObjectBox store, and DayChangeController active.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
