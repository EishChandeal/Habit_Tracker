import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:habit_tracker/data/models/dtos/dtos.dart';
import 'package:habit_tracker/domain/enums/enums.dart';
import 'package:habit_tracker/presentation/theme/app_theme.dart';

/// Panel displaying configuration details and start date for a habit.
class DetailsPanel extends StatelessWidget {
  final HabitDto habit;
  final HabitScheduleDto? activeSchedule;

  const DetailsPanel({
    super.key,
    required this.habit,
    this.activeSchedule,
  });

  @override
  Widget build(BuildContext context) {
    final createdFormatted = DateFormat('d MMMM yyyy').format(habit.createdAt.toLocal());
    final scheduleLabel = activeSchedule?.scheduleType.displayName ?? 'Daily';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            icon: Icons.calendar_today_outlined,
            title: 'Start Date',
            value: createdFormatted,
          ),
          const Divider(color: AppColors.surface, height: 18),
          _buildDetailRow(
            icon: Icons.repeat,
            title: 'Schedule',
            value: scheduleLabel,
          ),
          const Divider(color: AppColors.surface, height: 18),
          _buildDetailRow(
            icon: habit.type == HabitType.boolean
                ? Icons.check_circle_outline
                : Icons.numbers_outlined,
            title: 'Tracking Type',
            value: habit.type == HabitType.boolean
                ? 'Checkmark (Yes / No)'
                : 'Numeric (${_formatVal(habit.targetValue ?? 0)} ${habit.unit ?? ''})',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.blue),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.mutedGrey,
            fontFamily: AppTheme.fontPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
              fontFamily: AppTheme.fontPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatVal(double val) {
    if (val == val.roundToDouble()) {
      return val.toInt().toString();
    }
    return val.toStringAsFixed(1);
  }
}
