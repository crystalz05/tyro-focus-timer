import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/ticker.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../session/domain/entities/session.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../../session/presentation/bloc/session_event.dart';
import 'timer_event.dart';
import 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  final SessionBloc sessionBloc;
  int _workMinutes;
  int _shortBreakMinutes;
  int _longBreakMinutes;

  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({
    required Ticker ticker,
    required this.sessionBloc,
    int workMinutes = AppDurations.defaultWorkMinutes,
    int shortBreakMinutes = AppDurations.defaultShortBreakMinutes,
    int longBreakMinutes = AppDurations.defaultLongBreakMinutes,
  })  : _ticker = ticker,
        _workMinutes = workMinutes,
        _shortBreakMinutes = shortBreakMinutes,
        _longBreakMinutes = longBreakMinutes,
        super(TimerInitial(
        remainingSeconds: workMinutes * 60,
        totalSeconds: workMinutes * 60,
        sessionType: SessionType.work,
        completedWorkSessions: 0,
        selectedTag: AppStrings.defaultTags.first,
      )) {
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
    on<TimerTicked>(_onTicked);
    on<TimerSkipped>(_onSkipped);
    on<TimerTagChanged>(_onTagChanged);
  }

  // Called from SettingsScreen on Day 3 when durations change
  void updateDurations({
    required int workMinutes,
    required int shortBreakMinutes,
    required int longBreakMinutes,
  }) {
    _workMinutes = workMinutes;
    _shortBreakMinutes = shortBreakMinutes;
    _longBreakMinutes = longBreakMinutes;
    add(const TimerReset());
  }

  int _durationForType(SessionType type) {
    switch (type) {
      case SessionType.work:
        return _workMinutes * 60;
      case SessionType.shortBreak:
        return _shortBreakMinutes * 60;
      case SessionType.longBreak:
        return _longBreakMinutes * 60;
    }
  }

  SessionType _nextSessionType(SessionType current, int completedWork) {
    if (current != SessionType.work) return SessionType.work;
    if (completedWork % AppDurations.sessionsBeforeLongBreak == 0) {
      return SessionType.longBreak;
    }
    return SessionType.shortBreak;
  }

  Future<void> _onStarted(
      TimerStarted event, Emitter<TimerState> emit) async {
    emit(TimerRunning(
      remainingSeconds: event.duration,
      totalSeconds: event.duration,
      sessionType: state.sessionType,
      completedWorkSessions: state.completedWorkSessions,
      selectedTag: state.selectedTag,
    ));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: event.duration)
        .listen((remaining) => add(TimerTicked(remaining)));
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunning) {
      _tickerSubscription?.pause();
      emit(TimerPausedState(
        remainingSeconds: state.remainingSeconds,
        totalSeconds: state.totalSeconds,
        sessionType: state.sessionType,
        completedWorkSessions: state.completedWorkSessions,
        selectedTag: state.selectedTag,
      ));
    }
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    if (state is TimerPausedState) {
      _tickerSubscription?.resume();
      emit(TimerRunning(
        remainingSeconds: state.remainingSeconds,
        totalSeconds: state.totalSeconds,
        sessionType: state.sessionType,
        completedWorkSessions: state.completedWorkSessions,
        selectedTag: state.selectedTag,
      ));
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    final duration = _durationForType(state.sessionType);
    emit(TimerInitial(
      remainingSeconds: duration,
      totalSeconds: duration,
      sessionType: state.sessionType,
      completedWorkSessions: state.completedWorkSessions,
      selectedTag: state.selectedTag,
    ));
  }

  Future<void> _onTicked(
      TimerTicked event, Emitter<TimerState> emit) async {
    if (event.remainingSeconds > 0) {
      emit(TimerRunning(
        remainingSeconds: event.remainingSeconds,
        totalSeconds: state.totalSeconds,
        sessionType: state.sessionType,
        completedWorkSessions: state.completedWorkSessions,
        selectedTag: state.selectedTag,
      ));
    } else {
      _tickerSubscription?.cancel();

      // Save to DB if this was a work session
      if (state.sessionType == SessionType.work) {
        sessionBloc.add(SaveSessionEvent(
          Session(
            tag: state.selectedTag,
            durationSeconds: state.totalSeconds,
            startTime: DateTime.now()
                .subtract(Duration(seconds: state.totalSeconds))
                .millisecondsSinceEpoch,
            completed: true,
          ),
        ));
      }

      final newCompleted = state.sessionType == SessionType.work
          ? state.completedWorkSessions + 1
          : state.completedWorkSessions;

      emit(TimerComplete(
        remainingSeconds: 0,
        totalSeconds: state.totalSeconds,
        sessionType: state.sessionType,
        completedWorkSessions: newCompleted,
        selectedTag: state.selectedTag,
      ));

      // Brief pause then auto-advance to next session type
      await Future.delayed(const Duration(seconds: 1));
      final nextType = _nextSessionType(state.sessionType, newCompleted);
      final nextDuration = _durationForType(nextType);

      emit(TimerInitial(
        remainingSeconds: nextDuration,
        totalSeconds: nextDuration,
        sessionType: nextType,
        completedWorkSessions: newCompleted,
        selectedTag: state.selectedTag,
      ));
    }
  }

  void _onSkipped(TimerSkipped event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    final nextType =
    _nextSessionType(state.sessionType, state.completedWorkSessions);
    final nextDuration = _durationForType(nextType);
    emit(TimerInitial(
      remainingSeconds: nextDuration,
      totalSeconds: nextDuration,
      sessionType: nextType,
      completedWorkSessions: state.completedWorkSessions,
      selectedTag: state.selectedTag,
    ));
  }

  void _onTagChanged(TimerTagChanged event, Emitter<TimerState> emit) {
    emit(TimerInitial(
      remainingSeconds: state.remainingSeconds,
      totalSeconds: state.totalSeconds,
      sessionType: state.sessionType,
      completedWorkSessions: state.completedWorkSessions,
      selectedTag: event.tag,
    ));
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}