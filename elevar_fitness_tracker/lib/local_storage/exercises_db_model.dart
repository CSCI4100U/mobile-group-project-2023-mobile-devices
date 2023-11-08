import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'exercises_db_utils.dart';

class ExerciseDBModel {
  Future<int> insertExercise(Map<String,dynamic> exercise) async {
    final db = await DBUtils.init();
    return await db.insert('Exercises', exercise, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String,dynamic>> getExercise(String name) async {
    final db = await DBUtils.init();
    final List<Map<String,Object?>> result = await db.query(
      'Exercises', where: 'name = ?', whereArgs: [name]);
    return result[0];
  }

  Future<List<Map<String,dynamic>>> getAllExercises() async {
    final db = await DBUtils.init();
    return await db.query('Exercises');
  }

  Future<int> updateExercise(String name, int reps, double weight) async {
    final db = await DBUtils.init();
    final Map<String,Object> update = {'heavySetReps':reps, 'weight':weight};

    return await db.update(
      'Exercises', update, where: 'name = ?', whereArgs: [name]);
  }
}