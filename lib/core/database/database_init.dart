import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../logger/app_logger.dart';

class DatabaseInit {
  static final DatabaseInit _instance = DatabaseInit._internal();
  late Database _database;
  bool _isInitialized = false;

  factory DatabaseInit() {
    return _instance;
  }

  DatabaseInit._internal();

  Database get database => _database;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, 'acctally.db');

      _database = await openDatabase(
        path,
        version: 1,
        onCreate: onCreate,
        onUpgrade: onUpgrade,
      );

      _isInitialized = true;
      logger.info('Database initialized successfully');
    } catch (e) {
      logger.error('Failed to initialize database', e);
      rethrow;
    }
  }

  Future<void> onCreate(Database db, int version) async {
    try {
      await createTables(db);
      logger.info('Database tables created successfully');
    } catch (e) {
      logger.error('Error creating database tables', e);
      rethrow;
    }
  }

  Future<void> createTables(Database db) async {
    await createCostsTable(db);
    await createSalesTable(db);
  }

  Future<void> createCostsTable(Database db) async {
    await db.execute('''
      CREATE TABLE costs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        fixedCost REAL NOT NULL,
        variableCostPerUnit REAL NOT NULL,
        sellingPrice REAL NOT NULL,
        unit TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');
    logger.debug('costs table created');
  }

  Future<void> createSalesTable(Database db) async {
    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        costId INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        saleDate INTEGER NOT NULL,
        totalRevenue REAL NOT NULL,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        FOREIGN KEY(costId) REFERENCES costs(id) ON DELETE CASCADE
      )
    ''');
    logger.debug('sales table created');
  }

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    logger.info('Database upgraded from v$oldVersion to v$newVersion');
  }

  Future<void> closeDatabase() async {
    try {
      await _database.close();
      _isInitialized = false;
      logger.info('Database closed');
    } catch (e) {
      logger.error('Error closing database', e);
      rethrow;
    }
  }
}

final databaseInit = DatabaseInit();
