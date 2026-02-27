import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/notificate_service.dart';
import '../../../core/utils/ticker.dart';
import '../../../database/app_database.dart';
import '../../../database/session_dao.dart';
import '../../settings/data/settings_local_datasource.dart';
import '../../settings/presentation/cubit/settings_cubit.dart';
import '../../timer/presentation/bloc/timer_bloc.dart';
import '../data/datasources/session_local_datasource.dart';
import '../data/repositories/session_repository_impl.dart';
import '../domain/repositories/session_repository.dart';
import '../domain/usecases/get_all_sessions.dart';
import '../domain/usecases/get_today_sessions.dart';
import '../domain/usecases/get_weekly_sessions.dart';
import '../domain/usecases/save_session.dart';
import '../presentation/bloc/session_bloc.dart';

Future<void> registerSessionDependencies(GetIt sl) async {

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  final database =
  await $FloorAppDatabase.databaseBuilder('focus_timer.db').build();
  sl.registerSingleton<AppDatabase>(database);
  sl.registerSingleton<SessionDao>(database.sessionDao);

  // ── Services ───────────────────────────────────────────────────────────
  final notificationService = NotificationService();
  await notificationService.init();
  sl.registerSingleton<NotificationService>(notificationService);

  // ── Data sources ───────────────────────────────────────────────────────
  sl.registerSingleton<SessionLocalDatasource>(
    SessionLocalDatasourceImpl(sl<SessionDao>()),
  );
  sl.registerSingleton<SettingsLocalDatasource>(
    SettingsLocalDatasource(sl<SharedPreferences>()),
  );

  // ── Repository ─────────────────────────────────────────────────────────
  sl.registerSingleton<SessionRepository>(
    SessionRepositoryImpl(sl<SessionLocalDatasource>()),
  );

  // ── Use cases ──────────────────────────────────────────────────────────
  sl.registerSingleton(SaveSession(sl<SessionRepository>()));
  sl.registerSingleton(GetTodaySessions(sl<SessionRepository>()));
  sl.registerSingleton(GetWeeklySessions(sl<SessionRepository>()));
  sl.registerSingleton(GetAllSessions(sl<SessionRepository>()));

  // ── Blocs & Cubits ─────────────────────────────────────────────────────
  sl.registerSingleton<SettingsCubit>(
    SettingsCubit(sl<SettingsLocalDatasource>()),
  );

  sl.registerFactory<SessionBloc>(() => SessionBloc(
    saveSession: sl<SaveSession>(),
    getTodaySessions: sl<GetTodaySessions>(),
    getWeeklySessions: sl<GetWeeklySessions>(),
    getAllSessions: sl<GetAllSessions>(),
  ));

  // TimerBloc reads saved settings so durations survive app restarts
  final savedSettings = sl<SettingsCubit>().currentSettings;
  sl.registerFactory<TimerBloc>(() => TimerBloc(
    ticker: const Ticker(),
    sessionBloc: sl<SessionBloc>(),
    notificationService: sl<NotificationService>(),
    workMinutes: savedSettings.workMinutes,
    shortBreakMinutes: savedSettings.shortBreakMinutes,
    longBreakMinutes: savedSettings.longBreakMinutes,
  ));
}