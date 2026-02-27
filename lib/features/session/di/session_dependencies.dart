import 'package:get_it/get_it.dart';

import '../../../core/utils/ticker.dart';
import '../../../database/app_database.dart';
import '../../../database/session_dao.dart';
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

  final database = await $FloorAppDatabase
      .databaseBuilder('focus_timer.db')
      .build();
  sl.registerSingleton<AppDatabase>(database);
  sl.registerSingleton<SessionDao>(database.sessionDao);

  // Data sources
  sl.registerSingleton<SessionLocalDatasource>(
    SessionLocalDatasourceImpl(sl()),
  );

  // Repositories
  sl.registerSingleton<SessionRepository>(
    SessionRepositoryImpl(sl<SessionLocalDatasource>()),
  );

  // Use cases
  sl.registerSingleton(SaveSession(sl()));
  sl.registerSingleton(GetTodaySessions(sl()));
  sl.registerSingleton(GetWeeklySessions(sl()));
  sl.registerSingleton(GetAllSessions(sl()));

  sl.registerLazySingleton<SessionBloc>(() => SessionBloc(
    saveSession: sl<SaveSession>(),
    getTodaySessions: sl<GetTodaySessions>(),
    getWeeklySessions: sl<GetWeeklySessions>(),
    getAllSessions: sl<GetAllSessions>(),
  ));

  sl.registerLazySingleton<TimerBloc>(() => TimerBloc(
    ticker: const Ticker(),
    sessionBloc: sl<SessionBloc>(),
  ));
}