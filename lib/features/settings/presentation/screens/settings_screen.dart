import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../timer/presentation/bloc/timer_bloc.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../widget/duration_picker.dart';
import '../widget/toggle_row.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(AppStrings.settings),
        backgroundColor:
        isDark ? AppColors.darkBackground : AppColors.lightBackground,
        elevation: 0,
        foregroundColor:
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final cubit = context.read<SettingsCubit>();
          final timerBloc = context.read<TimerBloc>();
          final s = state.settings;

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // ── Timer durations ─────────────────────────────────────
              _SettingsSection(
                title: 'TIMER',
                isDark: isDark,
                children: [
                  DurationPicker(
                    label: AppStrings.workDuration,
                    value: s.workMinutes,
                    min: AppDurations.minSessionMinutes,
                    max: AppDurations.maxWorkMinutes,
                    onChanged: (val) {
                      cubit.updateWorkMinutes(val);
                      timerBloc.updateDurations(
                        workMinutes: val,
                        shortBreakMinutes: s.shortBreakMinutes,
                        longBreakMinutes: s.longBreakMinutes,
                      );
                    },
                  ),
                  const _Divider(),
                  DurationPicker(
                    label: AppStrings.shortBreakDuration,
                    value: s.shortBreakMinutes,
                    min: AppDurations.minSessionMinutes,
                    max: AppDurations.maxBreakMinutes,
                    onChanged: (val) {
                      cubit.updateShortBreakMinutes(val);
                      timerBloc.updateDurations(
                        workMinutes: s.workMinutes,
                        shortBreakMinutes: val,
                        longBreakMinutes: s.longBreakMinutes,
                      );
                    },
                  ),
                  const _Divider(),
                  DurationPicker(
                    label: AppStrings.longBreakDuration,
                    value: s.longBreakMinutes,
                    min: AppDurations.minSessionMinutes,
                    max: AppDurations.maxBreakMinutes,
                    onChanged: (val) {
                      cubit.updateLongBreakMinutes(val);
                      timerBloc.updateDurations(
                        workMinutes: s.workMinutes,
                        shortBreakMinutes: s.shortBreakMinutes,
                        longBreakMinutes: val,
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Preferences ─────────────────────────────────────────
              _SettingsSection(
                title: 'PREFERENCES',
                isDark: isDark,
                children: [
                  ToggleRow(
                    label: AppStrings.enableNotifications,
                    subtitle: 'Alert when a session ends',
                    value: s.notificationsEnabled,
                    onChanged: (_) async {
                      if (!s.notificationsEnabled) {
                        // Request permission the first time the user enables
                        await context
                            .read<SettingsCubit>()
                            .datasource
                            .prefs
                            .getBool('notif_permission_asked') == true
                            ? null
                            : _requestNotifPermission(context);
                      }
                      cubit.toggleNotifications();
                    },
                  ),
                  const _Divider(),
                  ToggleRow(
                    label: AppStrings.darkMode,
                    value: s.isDarkMode,
                    onChanged: (_) => cubit.toggleDarkMode(),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // App version footer
              Center(
                child: Text(
                  'Focus Timer v1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _requestNotifPermission(BuildContext context) async {
    // Show a quick explanation dialog before the OS permission prompt
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Stay in the loop'),
        content: const Text(
          'Focus Timer will notify you when a session ends so you never lose track of your time.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

// ─── Private helper widgets ──────────────────────────────────────────────────

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool isDark;

  const _SettingsSection({
    required this.title,
    required this.children,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 24,
      thickness: 0.5,
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
    );
  }
}