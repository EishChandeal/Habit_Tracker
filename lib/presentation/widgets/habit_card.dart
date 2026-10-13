import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/application/providers/providers.dart';
import 'package:habit_tracker/domain/enums/enums.dart';
import 'package:habit_tracker/domain/models/habit_day_status.dart';
import 'package:habit_tracker/presentation/theme/app_theme.dart';

/// Card component representing a habit on the Home screen.
/// Adheres to DESIGN.md dimensions (~375 x 109) and visual guidelines.
class HabitCard extends ConsumerWidget {
  final HabitDayStatus item;
  final VoidCallback? onTap;
  final VoidCallback? onCompletionTap;
  final VoidCallback? onLongPress;

  const HabitCard({
    super.key,
    required this.item,
    this.onTap,
    this.onCompletionTap,
    this.onLongPress,
  });

  bool get _isCompleted =>
      item.status == DayStatus.met || item.status == DayStatus.exceeded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habit = item.habit;
    final entry = item.entry;
    final streakAsync = ref.watch(habitStreakProvider(habit.id));

    // Accent color on the left edge: blue if completed, muted grey otherwise
    final accentColor = _isCompleted ? AppColors.blue : AppColors.mutedGrey;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          constraints: const BoxConstraints(minHeight: 96),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Narrow left-edge status accent bar
                Container(
                  width: 5,
                  color: accentColor,
                ),
                const SizedBox(width: 14),

                // Habit details (Title, schedule/streak, target)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          habit.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryText,
                            fontFamily: AppTheme.fontPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        _buildSubtitle(context, streakAsync.valueOrNull),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Completion / Value logging control
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: _buildCompletionControl(context, habit, entry),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context, dynamic streakResult) {
    final habit = item.habit;
    final List<Widget> metaItems = [];

    // Streak count if meaningful (> 0)
    final streakCount = streakResult?.currentStreak ?? 0;
    if (streakCount > 0) {
      metaItems.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.local_fire_department,
              size: 15,
              color: AppColors.orange,
            ),
            const SizedBox(width: 3),
            Text(
              '$streakCount ${streakCount == 1 ? 'day' : 'days'}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.orange,
                fontFamily: AppTheme.fontPrimary,
              ),
            ),
          ],
        ),
      );
    } else {
      // Schedule or target information
      final scheduleName = item.activeSchedule?.scheduleType.displayName ?? 'Daily';
      metaItems.add(
        Text(
          scheduleName,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.mutedGrey,
            fontFamily: AppTheme.fontPrimary,
          ),
        ),
      );
    }

    if (habit.type == HabitType.numeric && habit.targetValue != null) {
      metaItems.add(
        Text(
          ' • Target: ${_formatNumber(habit.targetValue!)} ${habit.unit ?? ''}',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.mutedGrey,
            fontFamily: AppTheme.fontPrimary,
          ),
        ),
      );
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: metaItems,
    );
  }

  Widget _buildCompletionControl(
    BuildContext context,
    dynamic habit,
    dynamic entry,
  ) {
    const double controlSize = 72;

    if (habit.type == HabitType.boolean) {
      final isDone = _isCompleted;
      return Semantics(
        button: true,
        label: isDone ? 'Mark habit as incomplete' : 'Mark habit as complete',
        child: Material(
          color: isDone ? AppColors.blue : AppColors.background,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: onCompletionTap,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: controlSize,
              height: controlSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: isDone
                    ? null
                    : Border.all(
                        color: AppColors.mutedGrey.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
              ),
              child: Center(
                child: isDone
                    ? const Icon(
                        Icons.check,
                        color: AppColors.controlText,
                        size: 32,
                      )
                    : const Text(
                        '—',
                        style: TextStyle(
                          color: AppColors.mutedGrey,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ),
      );
    } else {
      // Numeric Habit
      final hasValue = entry != null && entry.value > 0;
      final isDone = _isCompleted;

      return Semantics(
        button: true,
        label: hasValue ? 'Logged ${entry.value}' : 'Log numeric value',
        child: Material(
          color: isDone
              ? AppColors.blue
              : (hasValue ? AppColors.surface : AppColors.background),
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: onCompletionTap,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: controlSize,
              height: controlSize,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDone
                      ? AppColors.blue
                      : (hasValue
                          ? AppColors.blue.withValues(alpha: 0.5)
                          : AppColors.mutedGrey.withValues(alpha: 0.3)),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (hasValue) ...[
                    Text(
                      _formatNumber(entry.value),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDone ? AppColors.controlText : AppColors.primaryText,
                        fontFamily: AppTheme.fontPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (habit.unit != null && habit.unit!.isNotEmpty)
                      Text(
                        habit.unit!,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDone
                              ? AppColors.controlText.withValues(alpha: 0.8)
                              : AppColors.mutedGrey,
                          fontFamily: AppTheme.fontPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ] else ...[
                    const Text(
                      '—',
                      style: TextStyle(
                        color: AppColors.mutedGrey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (habit.unit != null && habit.unit!.isNotEmpty)
                      Text(
                        habit.unit!,
                        style: const TextStyle(
                          color: AppColors.mutedGrey,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }
}
