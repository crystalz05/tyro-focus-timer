import 'package:focus_timer/features/session/di/session_dependencies.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  await registerSessionDependencies(getIt);
}