import 'package:sqflite/sqflite.dart';
import '../models/category_model.dart';
import 'package:acctally/core/logger/app_logger.dart';

class CategoryRepository {
  final Database database;

  CategoryRepository(this.database);

  Future<int> createCategory(CategoryModel category) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final categoryWithTimestamp = category.copyWith(
        createdAt: now,
        updatedAt: now,
      );

      final id = await database.insert(
        'categories',
        categoryWithTimestamp.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      logger.info('Category created with ID: $id');
      return id;
    } catch (e) {
      logger.error('Error creating category', e);
      rethrow;
    }
  }

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final maps = await database.query('categories', orderBy: 'name ASC');
      return List.generate(maps.length, (i) => CategoryModel.fromMap(maps[i]));
    } catch (e) {
      logger.error('Error getting all categories', e);
      rethrow;
    }
  }

  Future<CategoryModel?> getCategoryById(int id) async {
    try {
      final maps = await database.query(
        'categories',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) return null;
      return CategoryModel.fromMap(maps.first);
    } catch (e) {
      logger.error('Error getting category by ID', e);
      rethrow;
    }
  }

  Future<CategoryModel?> getCategoryByName(String name) async {
    try {
      final maps = await database.query(
        'categories',
        where: 'name = ?',
        whereArgs: [name],
      );

      if (maps.isEmpty) return null;
      return CategoryModel.fromMap(maps.first);
    } catch (e) {
      logger.error('Error getting category by name', e);
      rethrow;
    }
  }

  Future<List<CategoryModel>> getByType(CostType costType) async {
    try {
      if (database == null) return [];
      final maps = await database.query(
        'categories',
        where: 'cost_type = ?',
        whereArgs: [costType.toStringValue()],
        orderBy: 'name ASC',
      );
      return List.generate(maps.length, (i) => CategoryModel.fromMap(maps[i]));
    } catch (e) {
      logger.error('Error getting categories by type', e);
      rethrow;
    }
  }

  Future<int> updateCategory(CategoryModel category) async {
    try {
      if (database == null) return 0;
      final categoryWithTimestamp = category.copyWith(
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );

      final count = await database.update(
        'categories',
        categoryWithTimestamp.toMap(),
        where: 'id = ?',
        whereArgs: [category.id],
      );
      logger.info('Category updated: $count rows');
      return count;
    } catch (e) {
      logger.error('Error updating category', e);
      rethrow;
    }
  }

  Future<int> deleteCategory(int id) async {
    try {
      if (database == null) return 0;
      final count = await database.delete(
        'categories',
        where: 'id = ?',
        whereArgs: [id],
      );
      logger.info('Category deleted: $count rows');
      return count;
    } catch (e) {
      logger.error('Error deleting category', e);
      rethrow;
    }
  }

  Future<int> getCategoryCount() async {
    try {
      if (database == null) return 0;
      final result = await database.rawQuery('SELECT COUNT(*) as count FROM categories');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      logger.error('Error getting category count', e);
      rethrow;
    }
  }
}
