import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../application/providers/providers.dart';
import '../../../data/models/dtos/dtos.dart';
import '../../../domain/enums/enums.dart';
import '../../navigation/app_router.dart';
import '../../screens/insights/insights_screen.dart';
import '../../theme/app_theme.dart';

/// Screen displaying historical dates in reverse chronological order,
/// allowing inspection and editing of habit entries on earlier dates.
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  late DateTime _selectedDate;
  late final List<DateTime> _pastDays;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime.utc(now.year, now.month, now.day);

    // Build the last 30 days in reverse chronological order (Today, Yesterday, ...)
    _pastDays = List.generate(30, (index) {
      final d = now.subtract(Duration(days: index));
      return DateTime.utc(d.year, d.month, d.day);
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(habitListProvider);
    final entriesAsync = ref.watch(entriesForDateProvider(_selectedDate));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        ),
        title: const Text(
          'History',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
            fontFamily: AppTheme.fontPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.insights_outlined, color: AppColors.blue),
            tooltip: 'View Insights',
            onPressed: () {
              appNavigateTo(context, AppRoutes.insights, const InsightsScreen());
            },
          ),
          IconButton(
            icon: const Icon(Icons.today_outlined, color: AppColors.primaryText),
            tooltip: 'Jump to today',
            onPressed: () {
              final now = DateTime.now();
              _selectDate(DateTime.utc(now.year, now.month, now.day));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Horizontal Date Strip (Last 30 days in reverse chronological order)
            _buildDateSelectorStrip(),

            const Divider(color: AppColors.surface, height: 1),

            // Main Content: Habit list for the selected date
            Expanded(
              child: habitsAsync.when(
                data: (habits) => entriesAsync.when(
                  data: (entries) => _buildHabitHistoryList(context, habits, entries),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.blue,
                      strokeWidth: 2.5,
                    ),
                  ),
                  error: (err, _) => Center(
                    child: Text(
                      'Error loading entries: $err',
                      style: const TextStyle(color: AppColors.mutedGrey),
                    ),
                  ),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.blue,
                    strokeWidth: 2.5,
                  ),
                ),
                error: (err, _) => Center(
                  child: Text(
                    'Error loading habits: $err',
                    style: const TextStyle(color: AppColors.mutedGrey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelectorStrip() {
    return Container(
      height: 84,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _pastDays.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final date = _pastDays[index];
          final isSelected = date == _selectedDate;
          final now = DateTime.now();
          final isToday = date == DateTime.utc(now.year, now.month, now.day);
          final weekdayStr = DateFormat('E').format(date); // Mon, Tue...
          final dayStr = DateFormat('d').format(date); // 14, 13...

          return Material(
            color: isSelected
                ? AppColors.blue
                : (isToday ? AppColors.surface : AppColors.surface.withValues(alpha: 0.6)),
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: () => _selectDate(date),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 58,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: isToday && !isSelected
                      ? Border.all(color: AppColors.orange, width: 1.5)
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      weekdayStr.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.controlText : AppColors.mutedGrey,
                        fontFamily: AppTheme.fontPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dayStr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.controlText : AppColors.primaryText,
                        fontFamily: AppTheme.fontPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHabitHistoryList(
    BuildContext context,
    List<HabitDto> allHabits,
    List<HabitEntryDto> entries,
  ) {
    final activeHabits = allHabits.where((h) => !h.isArchived).toList();

    if (activeHabits.isEmpty) {
      return const Center(
        child: Text(
          'No habits found. Create a habit on Home.',
          style: TextStyle(color: AppColors.mutedGrey),
        ),
      );
    }

    final entryMap = {for (final e in entries) e.habitId: e};
    final now = DateTime.now();
    final isToday = _selectedDate == DateTime.utc(now.year, now.month, now.day);

    int completedCount = 0;
    for (final h in activeHabits) {
      final entry = entryMap[h.id];
      if (entry != null && entry.value > 0) {
        if (h.type == HabitType.numeric && h.targetValue != null) {
          if (entry.value >= h.targetValue!) completedCount++;
        } else {
          completedCount++;
        }
      }
    }

    final dateFormatted = isToday
        ? 'Today (${DateFormat('d MMMM yyyy').format(_selectedDate)})'
        : DateFormat('EEEE, d MMMM yyyy').format(_selectedDate);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // Date Summary Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateFormatted,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                        fontFamily: AppTheme.fontPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$completedCount of ${activeHabits.length} habits recorded',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.mutedGrey,
                        fontFamily: AppTheme.fontPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: completedCount > 0
                      ? AppColors.blue.withValues(alpha: 0.2)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$completedCount / ${activeHabits.length}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: completedCount > 0 ? AppColors.blue : AppColors.mutedGrey,
                    fontFamily: AppTheme.fontPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Habits List for Selected Date
        ...activeHabits.map((habit) {
          final entry = entryMap[habit.id];
          final isCompleted = entry != null && entry.value > 0;
          final isNumeric = habit.type == HabitType.numeric;
          final habitColor = HabitVisuals.parseColor(habit.colorHex);
          final onHabitColor = HabitVisuals.getOnColor(habitColor);

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: Color.alphaBlend(habitColor.withValues(alpha: 0.04), AppColors.surface),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    // Color accent strip
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isCompleted ? habitColor : habitColor.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Habit icon badge
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: habitColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        HabitVisuals.getIcon(habit.iconName),
                        color: habitColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Habit title & details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habit.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryText,
                              fontFamily: AppTheme.fontPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isNumeric
                                ? 'Logged: ${_formatVal(entry?.value ?? 0)} / ${_formatVal(habit.targetValue ?? 0)} ${habit.unit ?? ''}'
                                : (isCompleted ? 'Completed' : 'Not logged'),
                            style: TextStyle(
                              fontSize: 12,
                              color: isCompleted ? habitColor : AppColors.mutedGrey,
                              fontFamily: AppTheme.fontPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Interactive Completion Control for this past date
                    Material(
                      color: isCompleted ? habitColor : AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _handleEntryTap(context, habit, entry),
                        child: Container(
                          width: 48,
                          height: 48,
                          alignment: Alignment.center,
                          child: isNumeric
                              ? Text(
                                  _formatVal(entry?.value ?? 0),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isCompleted
                                        ? onHabitColor
                                        : AppColors.mutedGrey,
                                  ),
                                )
                              : Icon(
                                  isCompleted ? Icons.check : Icons.remove,
                                  color: isCompleted
                                      ? onHabitColor
                                      : AppColors.mutedGrey,
                                  size: 22,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  void _handleEntryTap(
    BuildContext context,
    HabitDto habit,
    HabitEntryDto? entry,
  ) {
    if (habit.type == HabitType.boolean) {
      if (entry != null && entry.value > 0) {
        // Delete entry
        ref.read(entryActionsProvider.notifier).deleteEntry(
          entryId: entry.id,
          habitId: habit.id,
        );
      } else {
        // Log entry
        ref.read(entryActionsProvider.notifier).logEntry(
          habitId: habit.id,
          date: _selectedDate,
          value: 1.0,
        );
      }
    } else {
      // Numeric entry dialog / bottom sheet
      _showNumericInputDialog(context, habit, entry);
    }
  }

  void _showNumericInputDialog(
    BuildContext context,
    HabitDto habit,
    HabitEntryDto? entry,
  ) {
    final controller = TextEditingController(
      text: entry != null && entry.value > 0 ? _formatVal(entry.value) : '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Log ${habit.name} (${DateFormat('d MMM').format(_selectedDate)})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                  fontFamily: AppTheme.fontPrimary,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                autofocus: true,
                style: const TextStyle(color: AppColors.primaryText),
                decoration: InputDecoration(
                  labelText: 'Value (${habit.unit ?? 'units'})',
                  labelStyle: const TextStyle(color: AppColors.mutedGrey),
                  hintText: 'e.g. 500',
                  hintStyle: TextStyle(color: AppColors.mutedGrey.withValues(alpha: 0.5)),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (entry != null)
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(color: Colors.redAccent),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          ref.read(entryActionsProvider.notifier).deleteEntry(
                            entryId: entry.id,
                            habitId: habit.id,
                          );
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Clear'),
                      ),
                    ),
                  if (entry != null) const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        foregroundColor: AppColors.controlText,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final val = double.tryParse(controller.text.trim()) ?? 0.0;
                        if (val > 0) {
                          ref.read(entryActionsProvider.notifier).logEntry(
                            habitId: habit.id,
                            date: _selectedDate,
                            value: val,
                          );
                        }
                        Navigator.of(ctx).pop();
                      },
                      child: const Text(
                        'Save Entry',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatVal(double val) {
    if (val == val.roundToDouble()) {
      return val.toInt().toString();
    }
    return val.toStringAsFixed(1);
  }
}
