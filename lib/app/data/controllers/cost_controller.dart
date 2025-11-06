import 'package:get/get.dart';
import '../models/cost_entry_model.dart';
import '../repositories/cost_entry_repository.dart';
import '../repositories/category_repository.dart';
import 'package:acctally/core/logger/app_logger.dart';

class CostController extends GetxController {
  final CostEntryRepository costRepository;
  final CategoryRepository categoryRepository;

  CostController(this.costRepository, this.categoryRepository);

  final costEntries = <CostEntryModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;
  final totalCosts = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    getAllCostEntries();
    updateTotalCosts();
  }

  // Get all cost entries
  Future<void> getAllCostEntries() async {
    try {
      isLoading.value = true;
      error.value = '';
      costEntries.value = await costRepository.getAllCostEntries();
      await updateTotalCosts();
      logger.info('Loaded ${costEntries.length} cost entries');
    } catch (e) {
      error.value = 'Failed to load costs: $e';
      logger.error('Error loading cost entries', e);
    } finally {
      isLoading.value = false;
    }
  }

  // Create cost entry
  Future<int?> createCostEntry(CostEntryModel entry) async {
    try {
      isLoading.value = true;
      final id = await costRepository.createCostEntry(entry);
      await getAllCostEntries(); // Refresh
      logger.info('Cost entry created: ${entry.itemName}');
      return id;
    } catch (e) {
      error.value = 'Failed to create cost: $e';
      logger.error('Error creating cost entry', e);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Update cost entry
  Future<bool> updateCostEntry(CostEntryModel entry) async {
    try {
      isLoading.value = true;
      final count = await costRepository.updateCostEntry(entry);
      if (count > 0) {
        await getAllCostEntries();
        logger.info('Cost entry updated: ${entry.itemName}');
        return true;
      }
      return false;
    } catch (e) {
      error.value = 'Failed to update cost: $e';
      logger.error('Error updating cost entry', e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete cost entry
  Future<bool> deleteCostEntry(int id) async {
    try {
      isLoading.value = true;
      final count = await costRepository.deleteCostEntry(id);
      if (count > 0) {
        await getAllCostEntries();
        logger.info('Cost entry deleted: $id');
        return true;
      }
      return false;
    } catch (e) {
      error.value = 'Failed to delete cost: $e';
      logger.error('Error deleting cost entry', e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Get cost entries for product
  Future<List<CostEntryModel>> getCostEntriesForProduct(int productId) async {
    try {
      return await costRepository.getCostEntriesForProduct(productId);
    } catch (e) {
      logger.error('Error getting costs for product', e);
      return [];
    }
  }

  // Get cost entries by date range
  Future<List<CostEntryModel>> getCostEntriesByDateRange(
    int startDate,
    int endDate,
  ) async {
    try {
      return await costRepository.getCostEntriesByDateRange(startDate, endDate);
    } catch (e) {
      logger.error('Error getting costs by date range', e);
      return [];
    }
  }

  // Get total cost for product
  Future<double> getTotalCostForProduct(int productId) async {
    try {
      return await costRepository.getTotalCostForProduct(productId);
    } catch (e) {
      logger.error('Error getting total cost for product', e);
      return 0;
    }
  }

  // Get total fixed cost for product
  Future<double> getTotalFixedCostForProduct(int productId) async {
    try {
      return await costRepository.getTotalFixedCostForProduct(productId);
    } catch (e) {
      logger.error('Error getting fixed cost for product', e);
      return 0;
    }
  }

  // Get total variable cost for product
  Future<double> getTotalVariableCostForProduct(int productId) async {
    try {
      return await costRepository.getTotalVariableCostForProduct(productId);
    } catch (e) {
      logger.error('Error getting variable cost for product', e);
      return 0;
    }
  }

  // Update total costs
  Future<void> updateTotalCosts() async {
    try {
      totalCosts.value = await costRepository.getTotalAllCosts();
    } catch (e) {
      logger.error('Error updating total costs', e);
    }
  }

  // Get all categories
  Future<List<CostEntryModel>> getAllCosts() async {
    try {
      return await costRepository.getAllCostEntries();
    } catch (e) {
      logger.error('Error getting all costs', e);
      return [];
    }
  }
}
