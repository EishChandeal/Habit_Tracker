import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dashboard_providers.dart';

part 'day_change_provider.g.dart';

@Riverpod(keepAlive: true)
class DayChangeController extends _$DayChangeController
    with WidgetsBindingObserver {
  late DateTime _lastActiveDate;
  Timer? _midnightTimer;

  @override
  void build() {
    _lastActiveDate = _normalizeToDay(DateTime.now());
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      _midnightTimer?.cancel();
    });
    _scheduleMidnightTimer();
  }

  DateTime _normalizeToDay(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  bool _isNewDay(DateTime now) {
    final currentDay = _normalizeToDay(now);
    return currentDay.isAfter(_lastActiveDate);
  }

  void _onDayChanged() {
    _lastActiveDate = _normalizeToDay(DateTime.now());
    ref.invalidate(todayDashboardProvider);
    _scheduleMidnightTimer();
  }

  void _scheduleMidnightTimer() {
    _midnightTimer?.cancel();
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = nextMidnight.difference(now);

    _midnightTimer = Timer(durationUntilMidnight, () {
      _onDayChanged();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_isNewDay(DateTime.now())) {
        _onDayChanged();
      }
    }
  }
}
