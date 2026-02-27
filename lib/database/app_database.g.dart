// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  SessionDao? _sessionDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `sessions` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `tag` TEXT NOT NULL, `durationSeconds` INTEGER NOT NULL, `startTime` INTEGER NOT NULL, `completed` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SessionDao get sessionDao {
    return _sessionDaoInstance ??= _$SessionDao(database, changeListener);
  }
}

class _$SessionDao extends SessionDao {
  _$SessionDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _sessionModelInsertionAdapter = InsertionAdapter(
            database,
            'sessions',
            (SessionModel item) => <String, Object?>{
                  'id': item.id,
                  'tag': item.tag,
                  'durationSeconds': item.durationSeconds,
                  'startTime': item.startTime,
                  'completed': item.completed
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SessionModel> _sessionModelInsertionAdapter;

  @override
  Future<List<SessionModel>> getSessionsSince(int startOfDay) async {
    return _queryAdapter.queryList(
        'SELECT * FROM sessions WHERE startTime >= ?1 ORDER BY startTime DESC',
        mapper: (Map<String, Object?> row) => SessionModel(
            id: row['id'] as int?,
            tag: row['tag'] as String,
            durationSeconds: row['durationSeconds'] as int,
            startTime: row['startTime'] as int,
            completed: row['completed'] as int),
        arguments: [startOfDay]);
  }

  @override
  Future<List<SessionModel>> getAllSessions() async {
    return _queryAdapter.queryList(
        'SELECT * FROM sessions ORDER BY startTime DESC',
        mapper: (Map<String, Object?> row) => SessionModel(
            id: row['id'] as int?,
            tag: row['tag'] as String,
            durationSeconds: row['durationSeconds'] as int,
            startTime: row['startTime'] as int,
            completed: row['completed'] as int));
  }

  @override
  Future<void> insertSession(SessionModel session) async {
    await _sessionModelInsertionAdapter.insert(
        session, OnConflictStrategy.replace);
  }
}
