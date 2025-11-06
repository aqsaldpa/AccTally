import 'package:get/get.dart';
import '../models/product_model.dart';
import '../repositories/product_repository.dart';
import '../repositories/cost_entry_repository.dart';
import '../repositories/sale_entry_repository.dart';
import 'package:acctally/core/logger/app_logger.dart';
import 'bep_controller.dart';
import 'dashboard_controller.dart';

class ProductController extends GetxController {
  final ProductRepository repository;
  final CostEntryRepository costRepository;
  final SaleEntryRepository saleRepository;

  ProductController(
    this.repository,
    this.costRepository,
    this.saleRepository,
  );

  final products = <ProductModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getAllProducts();
  }

  // Get all products
  Future<void> getAllProducts() async {
    try {
      isLoading.value = true;
      error.value = '';
      products.value = await repository.getAllProducts();
      logger.info('Loaded ${products.length} products');
    } catch (e) {
      error.value = 'Failed to load products: $e';
      logger.error('Error loading products', e);
    } finally {
      isLoading.value = false;
    }
  }

  // Create product
  Future<int?> createProduct(ProductModel product) async {
    try {
      isLoading.value = true;
      final id = await repository.createProduct(product);
      await getAllProducts(); // Refresh list
      logger.info('Product created: ${product.name}');

      // Refresh BEP and Dashboard data
      _refreshRelatedControllers();

      return id;
    } catch (e) {
      error.value = 'Failed to create product: $e';
      logger.error('Error creating product', e);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void _refreshRelatedControllers() {
    try {
      // Refresh BEP controller
      final bepController = Get.find<BepController?>();
      bepController?.calculateAllBepResults();

      // Refresh Dashboard controller
      final dashboardController = Get.find<DashboardController?>();
      dashboardController?.loadDashboard();
    } catch (e) {
      // Controllers may not be initialized yet
      logger.debug('Controllers not ready for refresh: $e');
    }
  }

  // Update product
  Future<bool> updateProduct(ProductModel product) async {
    try {
      isLoading.value = true;
      final count = await repository.updateProduct(product);
      if (count > 0) {
        await getAllProducts(); // Refresh list
        logger.info('Product updated: ${product.name}');
        return true;
      }
      return false;
    } catch (e) {
      error.value = 'Failed to update product: $e';
      logger.error('Error updating product', e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete product (with cascade delete of related cost and sales entries)
  Future<bool> deleteProduct(int id) async {
    try {
      isLoading.value = true;

      // Delete related cost entries
      await costRepository.deleteCostEntriesByProductId(id);
      logger.info('Deleted cost entries for product: $id');

      // Delete related sales entries
      await saleRepository.deleteSaleEntriesByProductId(id);
      logger.info('Deleted sales entries for product: $id');

      // Delete product
      final count = await repository.deleteProduct(id);
      if (count > 0) {
        await getAllProducts(); // Refresh list
        logger.info('Product deleted with all related data: $id');
        return true;
      }
      return false;
    } catch (e) {
      error.value = 'Failed to delete product: $e';
      logger.error('Error deleting product', e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Get product by ID
  Future<ProductModel?> getProductById(int id) async {
    try {
      return await repository.getProductById(id);
    } catch (e) {
      logger.error('Error getting product by ID', e);
      return null;
    }
  }

  // Get product by name
  Future<ProductModel?> getProductByName(String name) async {
    try {
      return await repository.getProductByName(name);
    } catch (e) {
      logger.error('Error getting product by name', e);
      return null;
    }
  }

  // Check if product exists
  Future<bool> productExists(String name) async {
    try {
      return await repository.productExists(name);
    } catch (e) {
      logger.error('Error checking product existence', e);
      return false;
    }
  }

  // Get total product count
  Future<int> getProductCount() async {
    try {
      return await repository.getProductCount();
    } catch (e) {
      logger.error('Error getting product count', e);
      return 0;
    }
  }
}
