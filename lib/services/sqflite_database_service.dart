import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteDatabaseService {
  static final SqfliteDatabaseService _instance = SqfliteDatabaseService._internal();
  static Database? _database;

  factory SqfliteDatabaseService() {
    return _instance;
  }

  SqfliteDatabaseService._internal();

  Future<void> init() async {
    _database = await _initDatabase();
  }

  Future<Database> get database async {
    if (_database == null) {
      await init();
    }
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'exercise_timer_app.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_workouts(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        items TEXT NOT NULL,
        totalWorkoutTime INTEGER NOT NULL,
        workoutType TEXT NOT NULL,
        selectedLevel INTEGER,
        selectedSurvivalMode INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE workout_summaries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date INTEGER NOT NULL,
        performedSets TEXT NOT NULL,
        totalDurationInSeconds INTEGER NOT NULL,
        workoutName TEXT NOT NULL,
        workoutLevel INTEGER NOT NULL,
        isSurvivalMode INTEGER NOT NULL,
        workoutType TEXT NOT NULL,
        wasStoppedPrematurely INTEGER NOT NULL,
        totalSets INTEGER NOT NULL,
        completionDetails TEXT NOT NULL
      )
    ''');
  }
}