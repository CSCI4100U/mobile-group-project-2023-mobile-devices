import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'exercises_db_utils.dart';


/*
  Exercises currently in the database:
  
  List<Map<String, dynamic>> dummyData = [
    {'name':'Dumbell Bicep Curl'},
    {'name':'Barbell Bicep Curl'},
    {'name':'Hammer Curl'},
    {'name':'Lat Pulldown'},
    {'name':'Seated Cable Row'},
    {'name':'Bent-Over Row'},
    {'name':'Lateral Raise'},
    {'name':'Dumbell Shoulder Press'},
    {'name':'Overhead Barbell Press'},
    {'name':'Dumbell Chest Press'},
    {'name':'Bench Press'},
    {'name':'Chest Press'},
    {'name':'Pec Fly'},
    {'name':'Chest Cable Fly'},
    {'name':'Tricep Barbell Extension'},
    {'name':'Tricep Rope Pushdown'},
    {'name':'Tricep Pushdown'}
  ];
*/

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