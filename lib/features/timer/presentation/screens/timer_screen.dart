import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_timer/core/utils/time_formatter.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/timer_bloc.dart';
import '../bloc/timer_state.dart';
import '../widgets/timer_control.dart';
import '../widgets/timer_ring.dart';
import '../widgets/session_type_label.dart';
import '../widgets/tag_selector.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: isDark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Header row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${state.completedWorkSessions} sessions today',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          fontSize: 14,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.settings_outlined,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/settings'),
                      ),
                    ],
                  ),

                  const Spacer(),

                  SessionTypeLabel(
                    sessionType: state.sessionType,
                    completedSessions: state.completedWorkSessions,
                  ),

                  const SizedBox(height: 40),

                  TimerRing(
                    progress: state.progress,
                    timeText: TimeFormatter.format(state.remainingSeconds),
                    sessionType: state.sessionType,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 48),

                  TimerControls(state: state),

                  const Spacer(),

                  TagSelector(
                    selectedTag: state.selectedTag,
                    sessionType: state.sessionType,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}