import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/session.dart';

class WeeklyChart extends StatelessWidget {
  final List<Session> weeklySessions;

  const WeeklyChart({super.key, required this.weeklySessions});

  // Build a map of dayIndex (0=6 days ago, 6=today) → total focus minutes
  Map<int, int> _buildDayMinutes() {
    final now = DateTime.now();
    final Map<int, int> dayMinutes = {
      for (int i = 0; i <= 6; i++) i: 0,
    };

    for (final session in weeklySessions) {
      if (!session.completed) continue;
      final sessionDay = session.startDateTime;
      for (int i = 0; i <= 6; i++) {
        final day = now.subtract(Duration(days: 6 - i));
        if (sessionDay.year == day.year &&
            sessionDay.month == day.month &&
            sessionDay.day == day.day) {
          dayMinutes[i] = dayMinutes[i]! + session.durationMinutes;
          break;
        }
      }
    }
    return dayMinutes;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dayMinutes = _buildDayMinutes();
    final maxValue = dayMinutes.values.reduce((a, b) => a > b ? a : b);
    final maxY = (maxValue < 30 ? 60 : maxValue + 15).toDouble();

    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: BarChart(
        BarChartData(
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(
              color: (isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary)
                  .withOpacity(0.12),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final day = DateTime.now()
                      .subtract(Duration(days: 6 - value.toInt()));
                  final isToday = value.toInt() == 6;
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      isToday ? 'Today' : DateFormat('E').format(day),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isToday
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: isToday
                            ? AppColors.workColor
                            : isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: dayMinutes.entries.map((entry) {
            final isToday = entry.key == 6;
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.toDouble(),
                  color: isToday
                      ? AppColors.workColor
                      : AppColors.workColor.withOpacity(0.35),
                  width: 20,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}