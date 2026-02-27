import '../../../../core/usecases/usecase.dart';
import '../entities/session.dart';
import '../repositories/session_repository.dart';

class SaveSession extends UseCase<void, Session> {
  final SessionRepository repository;
  SaveSession(this.repository);

  @override
  Future<void> call(Session params) => repository.saveSession(params);
}