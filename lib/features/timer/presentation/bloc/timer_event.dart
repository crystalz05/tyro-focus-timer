import 'package:equatable/equatable.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();
  @override
  List<Object?> get props => [];
}

class TimerStarted extends TimerEvent {
  final int duration;
  const TimerStarted(this.duration);
  @override
  List<Object?> get props => [duration];
}

class TimerPaused extends TimerEvent {
  const TimerPaused();
}

class TimerResumed extends TimerEvent {
  const TimerResumed();
}

class TimerReset extends TimerEvent {
  const TimerReset();
}

class TimerTicked extends TimerEvent {
  final int remainingSeconds;
  const TimerTicked(this.remainingSeconds);
  @override
  List<Object?> get props => [remainingSeconds];
}

class TimerSkipped extends TimerEvent {
  const TimerSkipped();
}

class TimerTagChanged extends TimerEvent {
  final String tag;
  const TimerTagChanged(this.tag);
  @override
  List<Object?> get props => [tag];
}