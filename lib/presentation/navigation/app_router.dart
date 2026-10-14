import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/add/add_habit_screen.dart';
import '../screens/history/history_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/insights/insights_screen.dart';
import '../screens/settings/settings_screen.dart';

/// Central route names for Overman application.
class AppRoutes {
  static const home = '/';
  static const add = '/add';
  static const history = '/history';
  static const insights = '/insights';
  static const settings = '/settings';
}

/// GoRouter configuration providing declarative navigation for all prototype screens.
final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.add,
      builder: (context, state) => const AddHabitScreen(),
    ),
    GoRoute(
      path: AppRoutes.history,
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: AppRoutes.insights,
      builder: (context, state) => const InsightsScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

/// Safe navigation helper that uses GoRouter when available, or falls back to
/// standard Navigator push for isolated widget tests without a GoRouter ancestor.
void appNavigateTo(BuildContext context, String route, Widget fallbackScreen) {
  try {
    context.push(route);
  } catch (_) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => fallbackScreen),
    );
  }
}
