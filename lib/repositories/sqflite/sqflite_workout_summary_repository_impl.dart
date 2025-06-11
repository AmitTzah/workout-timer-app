import 'package:sqflite/sqflite.dart';
import '../../models/workout_summary.dart';
import '../../repositories/workout_summary_repository.dart';
import '../../services/sqflite_database_service.dart';
import 'dart:async';

class SqfliteWorkoutSummaryRepositoryImpl implements WorkoutSummaryRepository {
  final SqfliteDatabaseService _databaseService;
  final String _tableName = 'workout_summaries';

  final _summariesStreamController = StreamController<List<WorkoutSummary>>.broadcast();

  SqfliteWorkoutSummaryRepositoryImpl(this._databaseService);

  Future<void> _updateSummariesStream() async {
    final summaries = await getAllWorkoutSummaries();
    _summariesStreamController.add(summaries);
  }

  @override
  Future<void> saveWorkoutSummary(WorkoutSummary summary) async {
    final db = await _databaseService.database;
    await db.insert(
      _tableName,
      summary.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _updateSummariesStream();
  }

  @override
  Future<List<WorkoutSummary>> getAllWorkoutSummaries() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      final summary = WorkoutSummary.fromJson(maps[i]);
      summary.id = maps[i]['id'] as int?; // Manually assign the id from the database
      return summary;
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
    await _updateSummariesStream();
  }

  @override
  Future<void> clearAllWorkoutSummaries() async {
    final db = await _databaseService.database;
    await db.delete(_tableName);
    await _updateSummariesStream();
  }

  @override
  @override
  Stream<List<WorkoutSummary>> get workoutSummariesStream async* {
    yield await getAllWorkoutSummaries();
  }

  @override
  Stream<List<WorkoutSummary>> watchAllWorkoutSummaries() {
    _updateSummariesStream(); // Initial data push
    return _summariesStreamController.stream;
  }
}