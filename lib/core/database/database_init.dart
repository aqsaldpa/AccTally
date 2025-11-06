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
        version: 3,
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
    await createProductsTable(db);
    await createCategoriesTable(db);
    await createCostEntriesTable(db);
    await createSaleEntriesTable(db);
  }

  Future<void> createProductsTable(Database db) async {
    try {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS products (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL UNIQUE,
          description TEXT,
          unit TEXT NOT NULL DEFAULT 'unit',
          selling_price REAL NOT NULL,
          fixed_cost REAL NOT NULL DEFAULT 0,
          variable_cost REAL NOT NULL DEFAULT 0,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        )
      ''');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_products_name ON products(name)');
      logger.debug('products table created or exists');
    } catch (e) {
      logger.error('Error creating products table', e);
    }
  }

  Future<void> createCategoriesTable(Database db) async {
    try {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS categories (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL UNIQUE,
          cost_type TEXT NOT NULL CHECK(cost_type IN ('fixed', 'variable')),
          description TEXT,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        )
      ''');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_categories_name ON categories(name)');
      logger.debug('categories table created or exists');

      // Insert default categories
      await _insertDefaultCategories(db);
    } catch (e) {
      logger.error('Error creating categories table', e);
    }
  }

  Future<void> _insertDefaultCategories(Database db) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      // Default categories: only the essential ones as per requirements
      final defaultCategories = [
        {'name': 'Raw Materials', 'cost_type': 'variable'},
        {'name': 'Direct Labor', 'cost_type': 'variable'},
        {'name': 'Overhead', 'cost_type': 'fixed'},
      ];

      for (var category in defaultCategories) {
        await db.insert('categories', {
          'name': category['name'],
          'cost_type': category['cost_type'],
          'created_at': now,
          'updated_at': now,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
      logger.info('Default categories inserted: Raw Materials (variable), Direct Labor (variable), Overhead (fixed)');
    } catch (e) {
      logger.error('Error inserting default categories', e);
    }
  }

  Future<void> createCostEntriesTable(Database db) async {
    try {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS cost_entries (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          product_id INTEGER NOT NULL,
          category_id INTEGER NOT NULL,
          item_name TEXT NOT NULL,
          amount REAL NOT NULL,
          cost_date INTEGER NOT NULL,
          notes TEXT,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL,
          FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE,
          FOREIGN KEY(category_id) REFERENCES categories(id) ON DELETE RESTRICT
        )
      ''');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_cost_entries_product_id ON cost_entries(product_id)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_cost_entries_category_id ON cost_entries(category_id)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_cost_entries_date ON cost_entries(cost_date)');
      logger.debug('cost_entries table created or exists');
    } catch (e) {
      logger.error('Error creating cost_entries table', e);
    }
  }

  Future<void> createSaleEntriesTable(Database db) async {
    try {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS sale_entries (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          product_id INTEGER NOT NULL,
          quantity INTEGER NOT NULL,
          unit_price REAL NOT NULL,
          total_revenue REAL NOT NULL,
          sale_date INTEGER NOT NULL,
          notes TEXT,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL,
          FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE
        )
      ''');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_sale_entries_product_id ON sale_entries(product_id)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_sale_entries_date ON sale_entries(sale_date)');
      logger.debug('sale_entries table created or exists');
    } catch (e) {
      logger.error('Error creating sale_entries table', e);
    }
  }

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    logger.info('Database upgraded from v$oldVersion to v$newVersion');

    // Create tables if they don't exist (for existing databases that need migration)
    try {
      // Check if tables exist, if not create them
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name IN ('products', 'categories', 'cost_entries', 'sale_entries')"
      );

      if (tables.isEmpty || tables.length < 4) {
        logger.info('Creating missing tables during upgrade');
        await createTables(db);
      }
    } catch (e) {
      logger.error('Error checking/creating tables during upgrade', e);
    }
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
