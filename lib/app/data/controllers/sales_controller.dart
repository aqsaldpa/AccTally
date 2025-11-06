import 'package:get/get.dart';
import '../models/sale_entry_model.dart';
import '../repositories/sale_entry_repository.dart';
import 'package:acctally/core/logger/app_logger.dart';

class SalesController extends GetxController {
  final SaleEntryRepository repository;

  SalesController(this.repository);

  final saleEntries = <SaleEntryModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;
  final totalRevenue = 0.0.obs;
  final totalUnits = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getAllSaleEntries();
  }

  // Get all sale entries
  Future<void> getAllSaleEntries() async {
    try {
      isLoading.value = true;
      error.value = '';
      saleEntries.value = await repository.getAllSaleEntries();
      await updateTotals();
      logger.info('Loaded ${saleEntries.length} sale entries');
    } catch (e) {
      error.value = 'Failed to load sales: $e';
      logger.error('Error loading sale entries', e);
    } finally {
      isLoading.value = false;
    }
  }

  // Create sale entry
  Future<int?> createSaleEntry(SaleEntryModel entry) async {
    try {
      isLoading.value = true;
      final id = await repository.createSaleEntry(entry);
      await getAllSaleEntries(); // Refresh
      logger.info('Sale entry created');
      return id;
    } catch (e) {
      error.value = 'Failed to create sale: $e';
      logger.error('Error creating sale entry', e);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Update sale entry
  Future<bool> updateSaleEntry(SaleEntryModel entry) async {
    try {
      isLoading.value = true;
      final count = await repository.updateSaleEntry(entry);
      if (count > 0) {
        await getAllSaleEntries();
        logger.info('Sale entry updated');
        return true;
      }
      return false;
    } catch (e) {
      error.value = 'Failed to update sale: $e';
      logger.error('Error updating sale entry', e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete sale entry
  Future<bool> deleteSaleEntry(int id) async {
    try {
      isLoading.value = true;
      final count = await repository.deleteSaleEntry(id);
      if (count > 0) {
        await getAllSaleEntries();
        logger.info('Sale entry deleted: $id');
        return true;
      }
      return false;
    } catch (e) {
      error.value = 'Failed to delete sale: $e';
      logger.error('Error deleting sale entry', e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Get sale entries for product
  Future<List<SaleEntryModel>> getSaleEntriesForProduct(int productId) async {
    try {
      return await repository.getSaleEntriesForProduct(productId);
    } catch (e) {
      logger.error('Error getting sales for product', e);
      return [];
    }
  }

  // Get sale entries by date range
  Future<List<SaleEntryModel>> getSaleEntriesByDateRange(
    int startDate,
    int endDate,
  ) async {
    try {
      return await repository.getSaleEntriesByDateRange(startDate, endDate);
    } catch (e) {
      logger.error('Error getting sales by date range', e);
      return [];
    }
  }

  // Get total revenue for product
  Future<double> getTotalRevenueForProduct(int productId) async {
    try {
      return await repository.getTotalRevenueForProduct(productId);
    } catch (e) {
      logger.error('Error getting revenue for product', e);
      return 0;
    }
  }

  // Get total units for product
  Future<int> getTotalUnitsForProduct(int productId) async {
    try {
      return await repository.getTotalUnitsForProduct(productId);
    } catch (e) {
      logger.error('Error getting units for product', e);
      return 0;
    }
  }

  // Update totals
  Future<void> updateTotals() async {
    try {
      totalRevenue.value = await repository.getTotalAllRevenue();
      totalUnits.value = await repository.getTotalAllUnits();
    } catch (e) {
      logger.error('Error updating totals', e);
    }
  }

  // Get sale count
  Future<int> getSaleCount() async {
    try {
      return await repository.getSaleCount();
    } catch (e) {
      logger.error('Error getting sale count', e);
      return 0;
    }
  }
}
