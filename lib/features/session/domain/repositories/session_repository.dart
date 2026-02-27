import '../entities/session.dart';

abstract class SessionRepository {
  Future<void> saveSession(Session session);
  Future<List<Session>> getTodaySessions();
  Future<List<Session>> getWeeklySessions();
  Future<List<Session>> getAllSessions();
}