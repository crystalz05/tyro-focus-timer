import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/timer_state.dart';

class SessionTypeLabel extends StatelessWidget {
  final SessionType sessionType;
  final int completedSessions;

  const SessionTypeLabel({
    super.key,
    required this.sessionType,
    required this.completedSessions,
  });

  String get _label {
    switch (sessionType) {
      case SessionType.work:
        return AppStrings.workSession;
      case SessionType.shortBreak:
        return AppStrings.shortBreak;
      case SessionType.longBreak:
        return AppStrings.longBreak;
    }
  }

  Color get _color {
    switch (sessionType) {
      case SessionType.work:
        return AppColors.workColor;
      case SessionType.shortBreak:
        return AppColors.shortBreakColor;
      case SessionType.longBreak:
        return AppColors.longBreakColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AnimatedSwitcher gives a crossfade when session type changes
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Container(
            key: ValueKey(sessionType),
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: _color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _label,
              style: TextStyle(
                color: _color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Dots showing progress through the 4-session cycle
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(4, (index) {
            final filled = completedSessions % 4;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index < filled
                    ? AppColors.workColor
                    : AppColors.workColor.withOpacity(0.2),
              ),
            );
          }),
        ),
      ],
    );
  }
}