import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  late Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }

  DatabaseHelper.internal();

  Future<Database> initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'app.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT)');
  }

  Future<int> insertUser(String username, String password) async {
    Database db = await database;
    Map<String, dynamic> user = {
      'username': username,
      'password': password,
    };
    return await db.insert('users', user);
  }

  Future<bool> checkUser(String username, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> users = await db.query('users',
        where: 'username = ? AND password = ?', whereArgs: [username, password]);
    return users.isNotEmpty;
  }
}
