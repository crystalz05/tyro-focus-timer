import '../../../../core/usecases/usecase.dart';
import '../entities/session.dart';
import '../repositories/session_repository.dart';

class GetWeeklySessions extends UseCase<List<Session>, NoParams> {
  final SessionRepository repository;
  GetWeeklySessions(this.repository);

  @override
  Future<List<Session>> call(NoParams params) => repository.getWeeklySessions();
}