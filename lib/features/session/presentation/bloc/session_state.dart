import 'package:equatable/equatable.dart';
import '../../domain/entities/session.dart';

abstract class SessionState extends Equatable {
  const SessionState();
  @override
  List<Object?> get props => [];
}

class SessionInitial extends SessionState {}
class SessionLoading extends SessionState {}
class SessionSaved extends SessionState {}

class SessionLoaded extends SessionState {
  final List<Session> todaySessions;
  final List<Session> weeklySessions;
  final List<Session> allSessions;

  const SessionLoaded({
    required this.todaySessions,
    required this.weeklySessions,
    required this.allSessions,
  });

  int get todayMinutes => todaySessions
      .where((s) => s.completed)
      .fold(0, (sum, s) => sum + s.durationMinutes);

  int get weeklyMinutes => weeklySessions
      .where((s) => s.completed)
      .fold(0, (sum, s) => sum + s.durationMinutes);

  int get todayCount => todaySessions.where((s) => s.completed).length;

  @override
  List<Object?> get props => [todaySessions, weeklySessions, allSessions];
}

class SessionError extends SessionState {
  final String message;
  const SessionError(this.message);
  @override
  List<Object?> get props => [message];
}