
import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:focus_timer/features/session/domain/entities/session.dart';

@Entity(tableName: 'sessions')
class SessionModel {

  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String tag;
  final int durationSeconds;
  final int startTime;
  final int completed; // SQLite has no bool — 0 = false, 1 = true

  const SessionModel({
    this.id,
    required this.tag,
    required this.durationSeconds,
    required this.startTime,
    required this.completed,
  });

  factory SessionModel.fromEntity(Session session) => SessionModel(
      id: session.id,
      tag: session.tag,
      durationSeconds: session.durationSeconds,
      startTime: session.startTime,
      completed: session.completed ? 1 : 0,
  );

  Session toEntity() => Session(
      id: id,
      tag: tag,
      durationSeconds: durationSeconds,
      startTime: startTime,
      completed: completed == 1
  );
}