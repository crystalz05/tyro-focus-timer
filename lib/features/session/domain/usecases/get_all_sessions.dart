import '../../../../core/usecases/usecase.dart';
import '../entities/session.dart';
import '../repositories/session_repository.dart';

class GetAllSessions extends UseCase<List<Session>, NoParams> {
  final SessionRepository repository;
  GetAllSessions(this.repository);

  @override
  Future<List<Session>> call(NoParams params) => repository.getAllSessions();
}