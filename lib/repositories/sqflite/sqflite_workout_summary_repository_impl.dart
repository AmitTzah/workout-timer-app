import 'package:sqflite/sqflite.dart';
import '../../models/workout_summary.dart';
import '../../repositories/workout_summary_repository.dart';
import '../../services/sqflite_database_service.dart';

class SqfliteWorkoutSummaryRepositoryImpl implements WorkoutSummaryRepository {
  final SqfliteDatabaseService _databaseService;
  final String _tableName = 'workout_summaries';

  SqfliteWorkoutSummaryRepositoryImpl(this._databaseService);

  @override
  Future<void> saveWorkoutSummary(WorkoutSummary summary) async {
    final db = await _databaseService.database;
    await db.insert(
      _tableName,
      summary.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<WorkoutSummary>> getAllWorkoutSummaries() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return WorkoutSummary.fromJson(maps[i]);
    });
  }

  @override
  @override
  Future<void> deleteWorkoutSummary(int key) async {
    final db = await _databaseService.database;
    await db.delete(
      _tableName,
      where: 'id = ?', // Assuming 'id' column stores the key
      whereArgs: [key],
    );
  }

  @override
  Future<void> clearAllWorkoutSummaries() async {
    final db = await _databaseService.database;
    await db.delete(_tableName);
  }

  @override
  @override
  Stream<List<WorkoutSummary>> get workoutSummariesStream async* {
    yield await getAllWorkoutSummaries();
  }

  @override
  Stream<List<WorkoutSummary>> watchAllWorkoutSummaries() async* {
    yield await getAllWorkoutSummaries();
  }
}