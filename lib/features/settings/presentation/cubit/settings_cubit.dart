import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/settings_local_datasource.dart';
import '../../domain/entities/app_settings.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsLocalDatasource datasource;

  SettingsCubit(this.datasource)
      : super(SettingsState(datasource.loadSettings()));

  AppSettings get currentSettings => state.settings;

  Future<void> updateWorkMinutes(int minutes) =>
      _update(state.settings.copyWith(workMinutes: minutes));

  Future<void> updateShortBreakMinutes(int minutes) =>
      _update(state.settings.copyWith(shortBreakMinutes: minutes));

  Future<void> updateLongBreakMinutes(int minutes) =>
      _update(state.settings.copyWith(longBreakMinutes: minutes));

  Future<void> toggleNotifications() =>
      _update(state.settings.copyWith(
        notificationsEnabled: !state.settings.notificationsEnabled,
      ));

  Future<void> toggleDarkMode() =>
      _update(state.settings.copyWith(
        isDarkMode: !state.settings.isDarkMode,
      ));

  Future<void> _update(AppSettings updated) async {
    await datasource.saveSettings(updated);
    emit(SettingsState(updated));
  }
}