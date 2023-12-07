import 'routine_db_utils.dart';
import 'package:sqflite/sqflite.dart';

class RoutineDBModel {
  Future<int> insertExercise(Map<String,dynamic> routineItem) async {
    final Database db = await DBUtils.init();

    final id = await db.insert(
      'Routines', 
      routineItem,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id; 
  }

  Future<int> updateExercise(String exerciseName, int reps, double weight) async {
    final Database db = await DBUtils.init();
    int id = 0;
    
    if (reps == 0) {
      id = await db.update(
        'Routines',
        {'weight': weight},
        where: "exerciseName = ?",
        whereArgs: [exerciseName]
      );
    } else if (weight == 0.0) {
      id = await db.update(
        'Routines',
        {'heavySetReps': reps},
        where: "exerciseName = ?",
        whereArgs: [exerciseName]
      );
    } else {
      id = await db.update(
        'Routines',
        {'heavySetReps': reps, 'weight': weight},
        where: "exerciseName = ?",
        whereArgs: [exerciseName]
      );
    }
    return id;
  }

  Future<int> getNumDistinctRoutines() async {
    final Database db = await DBUtils.init();

    List<Map<String,Object?>> result = await db.query(
      'Routines',
      distinct: true,
      columns: ['routineName']
    );

    return result.length;
  }

  Future<List<dynamic>> getDistinctRoutineNames() async {
    final Database db = await DBUtils.init();

    List<Map<String,Object?>> result = await db.query(
      'Routines',
      distinct: true,
      columns: ['routineName']
    );

    return result.map((item) => item['routineName']).toList();
  }

  Future<List<Map<String,dynamic>>> getRoutine(String routineName) async {
    final Database db = await DBUtils.init();
    
    List<Map<String,Object?>> result = await db.query(
      'Routines',
      where: "routineName = ?",
      whereArgs: [routineName]
    );

    return result;
  }

  Future<List<Map<String,dynamic>>> getAllRoutineData() async {
    final Database db = await DBUtils.init();

    List<Map<String,Object?>> result = await db.query('Routines');

    return result;
  }

  Future<void> deleteDatabase() async {
    final Database db = await DBUtils.init();
    databaseFactory.deleteDatabase(db.path);
  }
}