import 'package:sqflite/sqflite.dart';
import '../models/cost_entry_model.dart';
import 'package:acctally/core/logger/app_logger.dart';

class CostEntryRepository {
  final Database database;

  CostEntryRepository(this.database);

  Future<int> createCostEntry(CostEntryModel entry) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final entryWithTimestamp = entry.copyWith(
        createdAt: now,
        updatedAt: now,
      );

      final id = await database.insert(
        'cost_entries',
        entryWithTimestamp.toMap(),
      );
      logger.info('Cost entry created with ID: $id');
      return id;
    } catch (e) {
      logger.error('Error creating cost entry', e);
      rethrow;
    }
  }

  Future<List<CostEntryModel>> getAllCostEntries() async {
    try {
      if (database == null) return [];
      final maps = await database.query('cost_entries', orderBy: 'cost_date DESC');
      return List.generate(maps.length, (i) => CostEntryModel.fromMap(maps[i]));
    } catch (e) {
      logger.error('Error getting all cost entries', e);
      rethrow;
    }
  }

  Future<CostEntryModel?> getCostEntryById(int id) async {
    try {
      if (database == null) return null;
      final maps = await database.query(
        'cost_entries',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) return null;
      return CostEntryModel.fromMap(maps.first);
    } catch (e) {
      logger.error('Error getting cost entry by ID', e);
      rethrow;
    }
  }

  Future<List<CostEntryModel>> getCostEntriesForProduct(int productId) async {
    try {
      if (database == null) return [];
      final maps = await database.query(
        'cost_entries',
        where: 'product_id = ?',
        whereArgs: [productId],
        orderBy: 'cost_date DESC',
      );
      return List.generate(maps.length, (i) => CostEntryModel.fromMap(maps[i]));
    } catch (e) {
      logger.error('Error getting cost entries for product', e);
      rethrow;
    }
  }

  Future<List<CostEntryModel>> getCostEntriesByCategory(int categoryId) async {
    try {
      if (database == null) return [];
      final maps = await database.query(
        'cost_entries',
        where: 'category_id = ?',
        whereArgs: [categoryId],
        orderBy: 'cost_date DESC',
      );
      return List.generate(maps.length, (i) => CostEntryModel.fromMap(maps[i]));
    } catch (e) {
      logger.error('Error getting cost entries by category', e);
      rethrow;
    }
  }

  Future<List<CostEntryModel>> getCostEntriesByDateRange(
    int startDate,
    int endDate,
  ) async {
    try {
      if (database == null) return [];
      final maps = await database.query(
        'cost_entries',
        where: 'cost_date BETWEEN ? AND ?',
        whereArgs: [startDate, endDate],
        orderBy: 'cost_date DESC',
      );
      return List.generate(maps.length, (i) => CostEntryModel.fromMap(maps[i]));
    } catch (e) {
      logger.error('Error getting cost entries by date range', e);
      rethrow;
    }
  }

  Future<int> updateCostEntry(CostEntryModel entry) async {
    try {
      final entryWithTimestamp = entry.copyWith(
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );

      final count = await database.update(
        'cost_entries',
        entryWithTimestamp.toMap(),
        where: 'id = ?',
        whereArgs: [entry.id],
      );
      logger.info('Cost entry updated: $count rows');
      return count;
    } catch (e) {
      logger.error('Error updating cost entry', e);
      rethrow;
    }
  }

  Future<int> deleteCostEntry(int id) async {
    try {
      final count = await database.delete(
        'cost_entries',
        where: 'id = ?',
        whereArgs: [id],
      );
      logger.info('Cost entry deleted: $count rows');
      return count;
    } catch (e) {
      logger.error('Error deleting cost entry', e);
      rethrow;
    }
  }

  // Delete all cost entries for a specific product
  Future<int> deleteCostEntriesByProductId(int productId) async {
    try {
      final count = await database.delete(
        'cost_entries',
        where: 'product_id = ?',
        whereArgs: [productId],
      );
      logger.info('Cost entries deleted for product $productId: $count rows');
      return count;
    } catch (e) {
      logger.error('Error deleting cost entries by product ID', e);
      rethrow;
    }
  }

  Future<double> getTotalCostForProduct(int productId) async {
    try {
      final result = await database.rawQuery(
        'SELECT SUM(amount) as total FROM cost_entries WHERE product_id = ?',
        [productId],
      );
      if (result.isEmpty) return 0;
      return (result.first['total'] as num?)?.toDouble() ?? 0;
    } catch (e) {
      logger.error('Error getting total cost for product', e);
      rethrow;
    }
  }

  Future<double> getTotalFixedCostForProduct(int productId) async {
    try {
      final result = await database.rawQuery(
        '''SELECT SUM(ce.amount) as total FROM cost_entries ce
           LEFT JOIN categories c ON ce.category_id = c.id
           WHERE ce.product_id = ? AND c.cost_type = 'fixed'
        ''',
        [productId],
      );
      if (result.isEmpty) return 0;
      return (result.first['total'] as num?)?.toDouble() ?? 0;
    } catch (e) {
      logger.error('Error getting total fixed cost for product', e);
      rethrow;
    }
  }

  Future<double> getTotalVariableCostForProduct(int productId) async {
    try {
      final result = await database.rawQuery(
        '''SELECT SUM(ce.amount) as total FROM cost_entries ce
           LEFT JOIN categories c ON ce.category_id = c.id
           WHERE ce.product_id = ? AND c.cost_type = 'variable'
        ''',
        [productId],
      );
      if (result.isEmpty) return 0;
      return (result.first['total'] as num?)?.toDouble() ?? 0;
    } catch (e) {
      logger.error('Error getting total variable cost for product', e);
      rethrow;
    }
  }

  Future<double> getTotalAllCosts() async {
    try {
      final result = await database.rawQuery(
        'SELECT SUM(amount) as total FROM cost_entries'
      );
      if (result.isEmpty) return 0;
      return (result.first['total'] as num?)?.toDouble() ?? 0;
    } catch (e) {
      logger.error('Error getting total all costs', e);
      rethrow;
    }
  }
}
