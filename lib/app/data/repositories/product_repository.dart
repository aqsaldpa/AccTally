import 'package:sqflite/sqflite.dart';
import '../models/product_model.dart';
import 'package:acctally/core/logger/app_logger.dart';

class ProductRepository {
  final Database database;

  ProductRepository(this.database);

  // CREATE
  Future<int> createProduct(ProductModel product) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final productWithTimestamp = product.copyWith(
        createdAt: now,
        updatedAt: now,
      );

      final id = await database.insert(
        'products',
        productWithTimestamp.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      logger.info('Product created with ID: $id');
      return id;
    } catch (e) {
      logger.error('Error creating product', e);
      rethrow;
    }
  }

  // READ - Get all products
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final maps = await database.query('products', orderBy: 'name ASC');
      return List.generate(maps.length, (i) => ProductModel.fromMap(maps[i]));
    } catch (e) {
      logger.error('Error getting all products', e);
      rethrow;
    }
  }

  // READ - Get product by ID
  Future<ProductModel?> getProductById(int id) async {
    try {
      final maps = await database.query(
        'products',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) return null;
      return ProductModel.fromMap(maps.first);
    } catch (e) {
      logger.error('Error getting product by ID', e);
      rethrow;
    }
  }

  // READ - Get product by name
  Future<ProductModel?> getProductByName(String name) async {
    try {
      final maps = await database.query(
        'products',
        where: 'name = ?',
        whereArgs: [name],
      );

      if (maps.isEmpty) return null;
      return ProductModel.fromMap(maps.first);
    } catch (e) {
      logger.error('Error getting product by name', e);
      rethrow;
    }
  }

  // UPDATE
  Future<int> updateProduct(ProductModel product) async {
    try {
      final productWithTimestamp = product.copyWith(
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );

      final count = await database.update(
        'products',
        productWithTimestamp.toMap(),
        where: 'id = ?',
        whereArgs: [product.id],
      );
      logger.info('Product updated: $count rows');
      return count;
    } catch (e) {
      logger.error('Error updating product', e);
      rethrow;
    }
  }

  // DELETE
  Future<int> deleteProduct(int id) async {
    try {
      final count = await database.delete(
        'products',
        where: 'id = ?',
        whereArgs: [id],
      );
      logger.info('Product deleted: $count rows');
      return count;
    } catch (e) {
      logger.error('Error deleting product', e);
      rethrow;
    }
  }

  // Get product count
  Future<int> getProductCount() async {
    try {
      final result = await database.rawQuery('SELECT COUNT(*) as count FROM products');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      logger.error('Error getting product count', e);
      rethrow;
    }
  }

  // Check if product exists
  Future<bool> productExists(String name) async {
    try {
      final product = await getProductByName(name);
      return product != null;
    } catch (e) {
      logger.error('Error checking product existence', e);
      rethrow;
    }
  }
}
