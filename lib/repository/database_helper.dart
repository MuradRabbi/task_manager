import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import '../models/task_model.dart';

class DBHelper{
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'task_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            '''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            date TEXT,
            isDone BOOL,
            isImportant BOOL
          )
          '''
        );
      },
    );
  }

  Future<int> insertTask(Task task) async {
    final Database db = await database;
    return db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTodos() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (index) {
      return Task(
        id: maps[index]['id'],
        title: maps[index]['title'],
        description: maps[index]['description'],
        date: maps[index]['date'],
        isDone: maps[index]['isDone'] == 1,
        isImportant: maps[index]['isImportant'] == 1
      );
    });
  }

  Future<void> updateTaskDoneStatus(int id, bool isDoneChecked) async {
    await _database!.update(
      'tasks',
      {'isDone': isDoneChecked ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateTask(int id, String title, String description, String date, bool isImportant) async {
    final db = await database;
    await db.update(
      'tasks',
      {
        'title': title,
        'description' : description,
        'date' : date,
        'isImportant' : isImportant
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}