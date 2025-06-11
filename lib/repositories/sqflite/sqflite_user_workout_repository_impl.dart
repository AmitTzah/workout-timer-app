import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:workout_timer_app/models/user_workout.dart';
import 'package:workout_timer_app/repositories/user_workout_repository.dart';
import 'package:workout_timer_app/services/sqflite_database_service.dart';

class SqfliteUserWorkoutRepositoryImpl implements UserWorkoutRepository {
  final SqfliteDatabaseService _databaseService;
  final String _tableName = 'user_workouts';

  SqfliteUserWorkoutRepositoryImpl(this._databaseService);

  @override
  Future<List<UserWorkout>> getAllWorkouts() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return UserWorkout.fromJson(maps[i]);
    });
  }

  @override
  Future<UserWorkout?> getWorkoutById(String id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return UserWorkout.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<void> saveWorkout(UserWorkout workout) async {
    final db = await _databaseService.database;
    await db.insert(
      _tableName,
      workout.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteWorkout(String id) async {
    final db = await _databaseService.database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Stream<List<UserWorkout>> watchAllWorkouts() async* {
    yield await getAllWorkouts();
  }

  @override
  Future<void> clearAllWorkouts() async {
    final db = await _databaseService.database;
    await db.delete(_tableName);
  }
}