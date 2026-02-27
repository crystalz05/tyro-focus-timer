import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/app_settings.dart';

class SettingsLocalDatasource {
  final SharedPreferences prefs;

  SettingsLocalDatasource(this.prefs);

  static const _keyWork = 'work_minutes';
  static const _keyShortBreak = 'short_break_minutes';
  static const _keyLongBreak = 'long_break_minutes';
  static const _keyNotifications = 'notifications_enabled';
  static const _keyDarkMode = 'is_dark_mode';

  // Synchronous — SharedPreferences caches values in memory at init
  AppSettings loadSettings() {
    return AppSettings(
      workMinutes: prefs.getInt(_keyWork) ?? 25,
      shortBreakMinutes: prefs.getInt(_keyShortBreak) ?? 5,
      longBreakMinutes: prefs.getInt(_keyLongBreak) ?? 15,
      notificationsEnabled: prefs.getBool(_keyNotifications) ?? true,
      isDarkMode: prefs.getBool(_keyDarkMode) ?? false,
    );
  }

  Future<void> saveSettings(AppSettings settings) async {
    await Future.wait([
      prefs.setInt(_keyWork, settings.workMinutes),
      prefs.setInt(_keyShortBreak, settings.shortBreakMinutes),
      prefs.setInt(_keyLongBreak, settings.longBreakMinutes),
      prefs.setBool(_keyNotifications, settings.notificationsEnabled),
      prefs.setBool(_keyDarkMode, settings.isDarkMode),
    ]);
  }
}