import 'package:flutter/foundation.dart';
import '../model/note_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Get the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB(String filePath) async {
    String? path = filePath;
    if (!kIsWeb) {
      final dbPath = await getApplicationDocumentsDirectory();
      path = join(dbPath.path, filePath);
    }
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // Create the database schema (tables)
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        title TEXT NOT NULL,                  
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  // Handle database upgrades (migrations)
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE notes ADD COLUMN createdAt TEXT');
      await db.execute('ALTER TABLE notes ADD COLUMN updatedAt TEXT');
    }
  }

  // Retrieve a note by its ID
  Future<Note?> getNoteById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Note.fromMap(result.first);
    }
    return null;
  }

  // Insert a new note
  Future<int> create(Map<String, dynamic> note) async {
    final db = await instance.database;
    return await db.insert('notes', note);
  }

  // Retrieve all notes
  Future<List<Map<String, dynamic>>> readAllNotes() async {
    final db = await instance.database;
    final result = await db.query('notes');
    debugPrint('Database result: $result');
    return result;
  }

  // Update an existing note
  Future<int> update(Map<String, dynamic> note) async {
    final db = await instance.database;
    final id = note['id'];
    return await db.update('notes', note, where: 'id = ?', whereArgs: [id]);
  }

  // Delete a note by its ID
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
