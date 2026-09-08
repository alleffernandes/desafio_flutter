import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  
  factory DatabaseService() {
    return _instance;
  }
  
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'orbytis_field.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE inspections(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        work_order_id TEXT,
        observation TEXT,
        photo_path TEXT,
        latitude REAL,
        longitude REAL,
        status TEXT,
        sync_error_message TEXT
      )
    ''');
  }

  Future<int> insert(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(
      'inspections',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getInspectionsByWorkOrderId(String id) async {
    final db = await database;
    return await db.query(
      'inspections',
      where: 'work_order_id = ?',
      whereArgs: [id],
    );
  }
}
