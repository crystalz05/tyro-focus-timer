import 'package:focus_timer/features/session/domain/entities/session.dart';
import 'package:focus_timer/features/session/domain/repositories/session_repository.dart';

import '../datasources/session_local_datasource.dart';
import '../models/session_model.dart';

class SessionRepositoryImpl implements SessionRepository {

  final SessionLocalDatasource datasource;
  SessionRepositoryImpl(this.datasource);

  @override
  Future<List<Session>> getAllSessions() async {
    final models = await datasource.getAllSessions();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Session>> getTodaySessions() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day).millisecondsSinceEpoch;

    final models = await datasource.getSessionsSince(startOfDay);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Session>> getWeeklySessions() async {
    final start = DateTime.now().subtract(const Duration(days: 6));
    final startOfWeek =
        DateTime(start.year, start.month, start.day).millisecondsSinceEpoch;
    final models = await datasource.getSessionsSince(startOfWeek);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveSession(Session session) =>
      datasource.saveSession(SessionModel.fromEntity(session));

}