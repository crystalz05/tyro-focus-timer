import 'package:equatable/equatable.dart';
import '../../domain/entities/session.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();
  @override
  List<Object?> get props => [];
}

class SaveSessionEvent extends SessionEvent {
  final Session session;
  const SaveSessionEvent(this.session);
  @override
  List<Object?> get props => [session];
}

class LoadSessionsEvent extends SessionEvent {
  const LoadSessionsEvent();
}