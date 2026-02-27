import 'package:equatable/equatable.dart';

enum SessionType { work, shortBreak, longBreak }

abstract class TimerState extends Equatable {
  final int remainingSeconds;
  final int totalSeconds;
  final SessionType sessionType;
  final int completedWorkSessions;
  final String selectedTag;

  const TimerState({
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.sessionType,
    required this.completedWorkSessions,
    required this.selectedTag,
  });

  // How far through the session we are — drives the ring progress
  double get progress =>
      totalSeconds > 0 ? 1 - (remainingSeconds / totalSeconds) : 0;

  @override
  List<Object?> get props => [
    remainingSeconds,
    totalSeconds,
    sessionType,
    completedWorkSessions,
    selectedTag,
  ];
}

class TimerInitial extends TimerState {
  const TimerInitial({
    required super.remainingSeconds,
    required super.totalSeconds,
    required super.sessionType,
    required super.completedWorkSessions,
    required super.selectedTag,
  });
}

class TimerRunning extends TimerState {
  const TimerRunning({
    required super.remainingSeconds,
    required super.totalSeconds,
    required super.sessionType,
    required super.completedWorkSessions,
    required super.selectedTag,
  });
}

class TimerPausedState extends TimerState {
  const TimerPausedState({
    required super.remainingSeconds,
    required super.totalSeconds,
    required super.sessionType,
    required super.completedWorkSessions,
    required super.selectedTag,
  });
}

class TimerComplete extends TimerState {
  const TimerComplete({
    required super.remainingSeconds,
    required super.totalSeconds,
    required super.sessionType,
    required super.completedWorkSessions,
    required super.selectedTag,
  });
}