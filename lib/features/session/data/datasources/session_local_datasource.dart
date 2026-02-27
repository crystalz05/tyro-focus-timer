import '../../../../database/session_dao.dart';
import '../models/session_model.dart';

abstract class SessionLocalDatasource {
  Future<void> saveSession(SessionModel session);
  Future<List<SessionModel>> getSessionsSince(int timestamp);
  Future<List<SessionModel>> getAllSessions();
}

class SessionLocalDatasourceImpl implements SessionLocalDatasource {
  final SessionDao sessionDao;
  SessionLocalDatasourceImpl(this.sessionDao);

  @override
  Future<void> saveSession(SessionModel session) =>
      sessionDao.insertSession(session);

  @override
  Future<List<SessionModel>> getSessionsSince(int timestamp) =>
      sessionDao.getSessionsSince(timestamp);

  @override
  Future<List<SessionModel>> getAllSessions() => sessionDao.getAllSessions();
}