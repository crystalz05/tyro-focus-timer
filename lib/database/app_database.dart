// After writing this file, run:
// dart run build_runner build --delete-conflicting-outputs
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../features/session/data/models/session_model.dart';
import 'session_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [SessionModel])
abstract class AppDatabase extends FloorDatabase {
  SessionDao get sessionDao;
}