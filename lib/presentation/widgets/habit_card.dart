import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/application/providers/providers.dart';
import 'package:habit_tracker/domain/enums/enums.dart';
import 'package:habit_tracker/domain/models/habit_day_status.dart';
import 'package:habit_tracker/presentation/theme/app_theme.dart';
import 'package:habit_tracker/presentation/widgets/details_panel.dart';
import 'package:habit_tracker/presentation/widgets/heatmap_panel.dart';
import 'package:habit_tracker/presentation/widgets/numeric_graph_panel.dart';
import 'package:habit_tracker/presentation/widgets/statistics_panel.dart';

/// Card component representing a habit on the Home screen.
/// Supports in-place expansion with circular panel sequence:
/// - Boolean habits: Heatmap → Statistics → Details → Heatmap
/// - Numeric habits: Heatmap → Statistics → Graph → Details → Heatmap
class HabitCard extends ConsumerStatefulWidget {
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

  @override
  ConsumerState<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends ConsumerState<HabitCard> {
  bool _isExpanded = false;
  int _activePanelIndex = 0;

  bool get _isCompleted =>
      widget.item.status == DayStatus.met ||
      widget.item.status == DayStatus.exceeded;

  List<String> get _panelTitles {
    if (widget.item.habit.type == HabitType.numeric) {
      return ['Heatmap', 'Statistics', 'Trend Graph', 'Details'];
    }
    return ['Heatmap', 'Statistics', 'Details'];
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        // Design requirement: Reopening a collapsed card always resets to the heatmap
        _activePanelIndex = 0;
      }
    });
    widget.onTap?.call();
  }

  void _previousPanel() {
    final count = _panelTitles.length;
    setState(() {
      _activePanelIndex = (_activePanelIndex - 1 + count) % count;
    });
  }

  void _nextPanel() {
    final count = _panelTitles.length;
    setState(() {
      _activePanelIndex = (_activePanelIndex + 1) % count;
    });
  }

  @override
  Widget build(BuildContext context) {
    final habit = widget.item.habit;
    final entry = widget.item.entry;
    final streakAsync = ref.watch(habitStreakProvider(habit.id));

    // Accent color on the left edge: blue if completed, muted grey otherwise
    final accentColor = _isCompleted ? AppColors.blue : AppColors.mutedGrey;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _toggleExpansion,
        onLongPress: widget.onLongPress,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(minHeight: 96),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Main Card Row
                IntrinsicHeight(
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
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
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
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    _isExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    size: 20,
                                    color: AppColors.mutedGrey,
                                  ),
                                ],
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

                // Expanded Panel Section
                if (_isExpanded) ...[
                  const Divider(color: AppColors.background, height: 1),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: _buildExpandedSection(context),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedSection(BuildContext context) {
    final titles = _panelTitles;
    final currentTitle = titles[_activePanelIndex];

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! < -100) {
            _nextPanel(); // Swipe left -> Next panel
          } else if (details.primaryVelocity! > 100) {
            _previousPanel(); // Swipe right -> Previous panel
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Circular navigation bar (< Title [Dots] >)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous button (<)
              IconButton(
                icon: const Icon(Icons.chevron_left, color: AppColors.primaryText),
                onPressed: _previousPanel,
                splashRadius: 20,
                tooltip: 'Previous panel',
              ),

              // Title and dots indicator
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentTitle.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: AppColors.primaryText,
                      fontFamily: AppTheme.fontPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(titles.length, (index) {
                      final isActive = index == _activePanelIndex;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                        width: isActive ? 12 : 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.blue : AppColors.mutedGrey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ],
              ),

              // Next button (>)
              IconButton(
                icon: const Icon(Icons.chevron_right, color: AppColors.primaryText),
                onPressed: _nextPanel,
                splashRadius: 20,
                tooltip: 'Next panel',
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Active Panel Content
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: KeyedSubtree(
              key: ValueKey<int>(_activePanelIndex),
              child: _buildPanelContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanelContent() {
    final habit = widget.item.habit;
    final isNumeric = habit.type == HabitType.numeric;

    if (_activePanelIndex == 0) {
      // 0: Heatmap (always first)
      return HeatmapPanel(habitId: habit.id);
    } else if (_activePanelIndex == 1) {
      // 1: Statistics
      return StatisticsPanel(habit: habit);
    } else if (isNumeric && _activePanelIndex == 2) {
      // 2: Numeric Graph (numeric only)
      return NumericGraphPanel(habit: habit);
    } else {
      // Last: Details
      return DetailsPanel(
        habit: habit,
        activeSchedule: widget.item.activeSchedule,
      );
    }
  }

  Widget _buildSubtitle(BuildContext context, dynamic streakResult) {
    final habit = widget.item.habit;
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
      final scheduleName =
          widget.item.activeSchedule?.scheduleType.displayName ?? 'Daily';
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
            onTap: widget.onCompletionTap,
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
            onTap: widget.onCompletionTap,
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
