import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:habit_tracker/data/database/app_database.dart';
import 'package:habit_tracker/application/providers/providers.dart';

import 'package:habit_tracker/presentation/theme/app_theme.dart';
import 'package:habit_tracker/presentation/navigation/app_router.dart';

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

    return MaterialApp.router(
      title: 'Habit Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
