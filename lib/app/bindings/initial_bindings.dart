import 'package:get/get.dart';
import 'package:acctally/core/database/database_init.dart';
import '../data/repositories/product_repository.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/cost_entry_repository.dart';
import '../data/repositories/sale_entry_repository.dart';
import '../data/controllers/product_controller.dart';
import '../data/controllers/category_controller.dart';
import '../data/controllers/cost_controller.dart';
import '../data/controllers/sales_controller.dart';
import '../data/controllers/bep_controller.dart';
import '../data/controllers/dashboard_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Get database instance
    final database = DatabaseInit().database;

    // Register Repositories as singletons
    Get.put<ProductRepository>(ProductRepository(database));
    Get.put<CategoryRepository>(CategoryRepository(database));
    Get.put<CostEntryRepository>(CostEntryRepository(database));
    Get.put<SaleEntryRepository>(SaleEntryRepository(database));

    // Register Controllers as singletons
    Get.put<ProductController>(
      ProductController(
        Get.find<ProductRepository>(),
        Get.find<CostEntryRepository>(),
        Get.find<SaleEntryRepository>(),
      ),
    );

    Get.put<CategoryController>(
      CategoryController(Get.find<CategoryRepository>()),
    );

    Get.put<CostController>(
      CostController(
        Get.find<CostEntryRepository>(),
        Get.find<CategoryRepository>(),
      ),
    );

    Get.put<SalesController>(
      SalesController(Get.find<SaleEntryRepository>()),
    );

    Get.put<BepController>(
      BepController(
        Get.find<ProductRepository>(),
        Get.find<CostEntryRepository>(),
        Get.find<SaleEntryRepository>(),
      ),
    );

    Get.put<DashboardController>(
      DashboardController(
        Get.find<ProductRepository>(),
        Get.find<CostEntryRepository>(),
        Get.find<SaleEntryRepository>(),
      ),
    );
  }
}
