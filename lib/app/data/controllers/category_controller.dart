import 'package:get/get.dart';
import '../models/category_model.dart';
import '../repositories/category_repository.dart';
import 'package:acctally/core/logger/app_logger.dart';

class CategoryController extends GetxController {
  final CategoryRepository repository;

  CategoryController(this.repository);

  final categories = <CategoryModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getAllCategories();
  }

  // Get all categories
  Future<void> getAllCategories() async {
    try {
      isLoading.value = true;
      error.value = '';
      categories.value = await repository.getAllCategories();
      logger.info('Loaded ${categories.length} categories');
    } catch (e) {
      error.value = 'Failed to load categories: $e';
      logger.error('Error loading categories', e);
    } finally {
      isLoading.value = false;
    }
  }

  // Create category
  Future<int?> createCategory(CategoryModel category) async {
    try {
      isLoading.value = true;
      final id = await repository.createCategory(category);
      await getAllCategories(); // Refresh
      logger.info('Category created: ${category.name}');
      return id;
    } catch (e) {
      error.value = 'Failed to create category: $e';
      logger.error('Error creating category', e);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Update category
  Future<bool> updateCategory(CategoryModel category) async {
    try {
      isLoading.value = true;
      final count = await repository.updateCategory(category);
      if (count > 0) {
        await getAllCategories();
        logger.info('Category updated: ${category.name}');
        return true;
      }
      return false;
    } catch (e) {
      error.value = 'Failed to update category: $e';
      logger.error('Error updating category', e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete category
  Future<bool> deleteCategory(int id) async {
    try {
      isLoading.value = true;
      final count = await repository.deleteCategory(id);
      if (count > 0) {
        await getAllCategories();
        logger.info('Category deleted: $id');
        return true;
      }
      return false;
    } catch (e) {
      error.value = 'Failed to delete category: $e';
      logger.error('Error deleting category', e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Get category by ID
  Future<CategoryModel?> getCategoryById(int id) async {
    try {
      return await repository.getCategoryById(id);
    } catch (e) {
      logger.error('Error getting category', e);
      return null;
    }
  }

  // Get category count
  Future<int> getCategoryCount() async {
    try {
      return await repository.getCategoryCount();
    } catch (e) {
      logger.error('Error getting category count', e);
      return 0;
    }
  }
}
