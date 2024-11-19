import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static DatabaseHelper databaseHelper = DatabaseHelper._();

  Database? _database;
  String databaseName = 'contact.db';
  String tableName = 'contact';

  Future<Database> get database async => _database ?? await initDatabase();

  Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, databaseName);
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        String sql = '''
        CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          phone TEXT NOT NULL,
          email TEXT NOT NULL
        )
        ''';
        db.execute(sql);
      },
    );
  }

  Future<bool> contactExists(int id) async {
    final db = await database;
    String sql = '''
    SELECT * FROM $tableName WHERE id = ?
    ''';
    List<Map<String, Object?>> result = await db.rawQuery(sql, [id]);
    return result.isNotEmpty;
  }

  Future<int> addToDatabase(
      String name, String phone, String email) async {
    final db = await database;
    String sql = '''
    INSERT INTO $tableName(
    name,phone,email
    ) VALUES (?, ?, ?)
    ''';
    List args = [name,phone,email];
    return await db.rawInsert(sql, args);
  }

  Future<List<Map<String, Object?>>> readAllNotes() async {
    final db = await database;
    String sql = '''
    SELECT * FROM $tableName
    ''';
    return await db.rawQuery(sql);
  }

  Future<Future<List<Map<String, Object?>>>> readNotesByTitle(String name) async {
    final db = await database;
    String sql = '''
    SELECT * FROM $tableName WHERE title LIKE '$name%'
    ''';
    return db.rawQuery(sql);
  }

  Future<int> updateNotes(int id, String name, String phone, String email) async {
    final db = await database;
    String sql = '''
    UPDATE $tableName SET name = ?, phone = ?, email = ? WHERE id = ?
    ''';
    List args = [name,phone,email, id];
    return await db.rawUpdate(sql, args);
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    String sql = '''
    DELETE FROM $tableName WHERE id = ?
    ''';
    List args = [id];
    return await db.rawDelete(sql, args);
  }
}