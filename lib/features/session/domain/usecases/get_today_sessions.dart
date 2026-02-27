import '../../../../core/usecases/usecase.dart';
import '../entities/session.dart';
import '../repositories/session_repository.dart';

class GetTodaySessions extends UseCase<List<Session>, NoParams> {
  final SessionRepository repository;
  GetTodaySessions(this.repository);

  @override
  Future<List<Session>> call(NoParams params) => repository.getTodaySessions();
}