import 'package:equatable/equatable.dart';

class Session extends Equatable {

  final int? id;
  final String tag;
  final int durationSeconds;
  final int startTime; // millisecondsSinceEpoch
  final bool completed;

  const Session({
    this.id,
    required this.tag,
    required this.durationSeconds,
    required this.startTime,
    required this.completed,
  });

  int get durationMinutes => durationSeconds ~/ 60;
  DateTime get startDateTime => DateTime.fromMillisecondsSinceEpoch(startTime);

  @override
  List<Object?> get props => [id, tag, durationSeconds, startTime, completed];
}