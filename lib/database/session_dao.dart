import 'package:floor/floor.dart';
import '../features/session/data/models/session_model.dart';

@dao
abstract class SessionDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSession(SessionModel session);

  @Query('SELECT * FROM sessions WHERE startTime >= :startOfDay ORDER BY startTime DESC')
  Future<List<SessionModel>> getSessionsSince(int startOfDay);

  @Query('SELECT * FROM sessions ORDER BY startTime DESC')
  Future<List<SessionModel>> getAllSessions();
}