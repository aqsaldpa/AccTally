import 'package:sqflite/sqflite.dart';
import '../models/sale_entry_model.dart';
import 'package:acctally/core/logger/app_logger.dart';

class SaleEntryRepository {
  final Database database;

  SaleEntryRepository(this.database);

  Future<int> createSaleEntry(SaleEntryModel entry) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final entryWithTimestamp = entry.copyWith(
        createdAt: now,
        updatedAt: now,
      );

      final id = await database.insert(
        'sale_entries',
        entryWithTimestamp.toMap(),
      );
      logger.info('Sale entry created with ID: $id');
      return id;
    } catch (e) {
      logger.error('Error creating sale entry', e);
      rethrow;
    }
  }

  Future<List<SaleEntryModel>> getAllSaleEntries() async {
    try {
      if (database == null) return [];
      final maps = await database.query('sale_entries', orderBy: 'sale_date DESC');
      return List.generate(maps.length, (i) => SaleEntryModel.fromMap(maps[i]));
    } catch (e) {
      logger.error('Error getting all sale entries', e);
      rethrow;
    }
  }

  Future<SaleEntryModel?> getSaleEntryById(int id) async {
    try {
      if (database == null) return null;
      final maps = await database.query(
        'sale_entries',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) return null;
      return SaleEntryModel.fromMap(maps.first);
    } catch (e) {
      logger.error('Error getting sale entry by ID', e);
      rethrow;
    }
  }

  Future<List<SaleEntryModel>> getSaleEntriesForProduct(int productId) async {
    try {
      if (database == null) return [];
      final maps = await database.query(
        'sale_entries',
        where: 'product_id = ?',
        whereArgs: [productId],
        orderBy: 'sale_date DESC',
      );
      return List.generate(maps.length, (i) => SaleEntryModel.fromMap(maps[i]));
    } catch (e) {
      logger.error('Error getting sale entries for product', e);
      rethrow;
    }
  }

  Future<List<SaleEntryModel>> getSaleEntriesByDateRange(
    int startDate,
    int endDate,
  ) async {
    try {
      if (database == null) return [];
      final maps = await database.query(
        'sale_entries',
        where: 'sale_date BETWEEN ? AND ?',
        whereArgs: [startDate, endDate],
        orderBy: 'sale_date DESC',
      );
      return List.generate(maps.length, (i) => SaleEntryModel.fromMap(maps[i]));
    } catch (e) {
      logger.error('Error getting sale entries by date range', e);
      rethrow;
    }
  }

  Future<int> updateSaleEntry(SaleEntryModel entry) async {
    try {
      final entryWithTimestamp = entry.copyWith(
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );

      final count = await database.update(
        'sale_entries',
        entryWithTimestamp.toMap(),
        where: 'id = ?',
        whereArgs: [entry.id],
      );
      logger.info('Sale entry updated: $count rows');
      return count;
    } catch (e) {
      logger.error('Error updating sale entry', e);
      rethrow;
    }
  }

  Future<int> deleteSaleEntry(int id) async {
    try {
      final count = await database.delete(
        'sale_entries',
        where: 'id = ?',
        whereArgs: [id],
      );
      logger.info('Sale entry deleted: $count rows');
      return count;
    } catch (e) {
      logger.error('Error deleting sale entry', e);
      rethrow;
    }
  }

  // Delete all sale entries for a specific product
  Future<int> deleteSaleEntriesByProductId(int productId) async {
    try {
      final count = await database.delete(
        'sale_entries',
        where: 'product_id = ?',
        whereArgs: [productId],
      );
      logger.info('Sale entries deleted for product $productId: $count rows');
      return count;
    } catch (e) {
      logger.error('Error deleting sale entries by product ID', e);
      rethrow;
    }
  }

  Future<double> getTotalRevenueForProduct(int productId) async {
    try {
      final result = await database.rawQuery(
        'SELECT SUM(total_revenue) as total FROM sale_entries WHERE product_id = ?',
        [productId],
      );
      if (result.isEmpty) return 0;
      return (result.first['total'] as num?)?.toDouble() ?? 0;
    } catch (e) {
      logger.error('Error getting total revenue for product', e);
      rethrow;
    }
  }

  Future<int> getTotalUnitsForProduct(int productId) async {
    try {
      final result = await database.rawQuery(
        'SELECT SUM(quantity) as total FROM sale_entries WHERE product_id = ?',
        [productId],
      );
      if (result.isEmpty) return 0;
      return (result.first['total'] as num?)?.toInt() ?? 0;
    } catch (e) {
      logger.error('Error getting total units for product', e);
      rethrow;
    }
  }

  Future<double> getTotalAllRevenue() async {
    try {
      final result = await database.rawQuery(
        'SELECT SUM(total_revenue) as total FROM sale_entries'
      );
      if (result.isEmpty) return 0;
      return (result.first['total'] as num?)?.toDouble() ?? 0;
    } catch (e) {
      logger.error('Error getting total all revenue', e);
      rethrow;
    }
  }

  Future<int> getTotalAllUnits() async {
    try {
      final result = await database.rawQuery(
        'SELECT SUM(quantity) as total FROM sale_entries'
      );
      if (result.isEmpty) return 0;
      return (result.first['total'] as num?)?.toInt() ?? 0;
    } catch (e) {
      logger.error('Error getting total all units', e);
      rethrow;
    }
  }

  Future<int> getSaleCount() async {
    try {
      final result = await database.rawQuery(
        'SELECT COUNT(*) as count FROM sale_entries'
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      logger.error('Error getting sale count', e);
      rethrow;
    }
  }
}
