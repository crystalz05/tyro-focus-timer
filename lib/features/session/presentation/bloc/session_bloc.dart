import 'package:bloc/bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_all_sessions.dart';
import '../../domain/usecases/get_today_sessions.dart';
import '../../domain/usecases/get_weekly_sessions.dart';
import '../../domain/usecases/save_session.dart';
import 'session_event.dart';
import 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final SaveSession saveSession;
  final GetTodaySessions getTodaySessions;
  final GetWeeklySessions getWeeklySessions;
  final GetAllSessions getAllSessions;

  SessionBloc({
    required this.saveSession,
    required this.getTodaySessions,
    required this.getWeeklySessions,
    required this.getAllSessions,
  }) : super(SessionInitial()) {
    on<SaveSessionEvent>(_onSaveSession);
    on<LoadSessionsEvent>(_onLoadSessions);
  }

  Future<void> _onSaveSession(
      SaveSessionEvent event,
      Emitter<SessionState> emit,
      ) async {
    try {
      await saveSession(event.session);
      emit(SessionSaved());
      add(const LoadSessionsEvent());
    } catch (e) {
      emit(SessionError(e.toString()));
    }
  }

  Future<void> _onLoadSessions(
      LoadSessionsEvent event,
      Emitter<SessionState> emit,
      ) async {
    emit(SessionLoading());
    try {
      final today = await getTodaySessions(const NoParams());
      final weekly = await getWeeklySessions(const NoParams());
      final all = await getAllSessions(const NoParams());
      emit(SessionLoaded(
        todaySessions: today,
        weeklySessions: weekly,
        allSessions: all,
      ));
    } catch (e) {
      emit(SessionError(e.toString()));
    }
  }
}