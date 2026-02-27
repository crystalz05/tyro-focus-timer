import 'package:equatable/equatable.dart';
import '../../../../core/constants/app_durations.dart';

class AppSettings extends Equatable {
  final int workMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final bool notificationsEnabled;
  final bool isDarkMode;

  const AppSettings({
    this.workMinutes = AppDurations.defaultWorkMinutes,
    this.shortBreakMinutes = AppDurations.defaultShortBreakMinutes,
    this.longBreakMinutes = AppDurations.defaultLongBreakMinutes,
    this.notificationsEnabled = true,
    this.isDarkMode = false,
  });

  AppSettings copyWith({
    int? workMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    bool? notificationsEnabled,
    bool? isDarkMode,
  }) {
    return AppSettings(
      workMinutes: workMinutes ?? this.workMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  @override
  List<Object?> get props => [
    workMinutes,
    shortBreakMinutes,
    longBreakMinutes,
    notificationsEnabled,
    isDarkMode,
  ];
}