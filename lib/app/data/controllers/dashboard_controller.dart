import 'package:get/get.dart';
import '../models/summary_models.dart';
import '../models/product_model.dart';
import '../repositories/product_repository.dart';
import '../repositories/cost_entry_repository.dart';
import '../repositories/sale_entry_repository.dart';
import 'package:acctally/core/logger/app_logger.dart';

class DashboardController extends GetxController {
  final ProductRepository productRepository;
  final CostEntryRepository costRepository;
  final SaleEntryRepository saleRepository;

  DashboardController(
    this.productRepository,
    this.costRepository,
    this.saleRepository,
  );

  final overallSummary = Rxn<OverallSummary>();
  final productSummaries = <ProductSummary>[].obs;
  final products = <ProductModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  // Load all dashboard data
  Future<void> loadDashboard() async {
    try {
      isLoading.value = true;
      error.value = '';

      await Future.wait([
        loadOverallSummary(),
        loadProductSummaries(),
      ]);

      logger.info('Dashboard loaded successfully');
    } catch (e) {
      error.value = 'Failed to load dashboard: $e';
      logger.error('Error loading dashboard', e);
    } finally {
      isLoading.value = false;
    }
  }

  // Get overall summary
  Future<void> loadOverallSummary() async {
    try {
      final totalCosts = await costRepository.getTotalAllCosts();
      final totalRevenue = await saleRepository.getTotalAllRevenue();
      final profitLoss = totalRevenue - totalCosts;
      final totalProducts = await productRepository.getProductCount();
      final totalSales = await saleRepository.getSaleCount();

      overallSummary.value = OverallSummary(
        totalCosts: totalCosts,
        totalRevenue: totalRevenue,
        profitLoss: profitLoss,
        totalProducts: totalProducts,
        totalSales: totalSales,
        isOverallProfit: profitLoss >= 0,
      );

      logger.info('Overall summary loaded');
    } catch (e) {
      logger.error('Error loading overall summary', e);
    }
  }

  // Get product summaries
  Future<void> loadProductSummaries() async {
    try {
      final allProducts = await productRepository.getAllProducts();
      final summaries = <ProductSummary>[];

      for (var product in allProducts) {
        final totalFixedCost = await costRepository.getTotalFixedCostForProduct(product.id!);
        final totalVariableCost = await costRepository.getTotalVariableCostForProduct(product.id!);
        final totalUnitsSold = await saleRepository.getTotalUnitsForProduct(product.id!);
        final totalRevenue = await saleRepository.getTotalRevenueForProduct(product.id!);
        final totalCost = totalFixedCost + (totalUnitsSold * product.variableCost);
        final profitLoss = totalRevenue - totalCost;

        summaries.add(ProductSummary(
          productId: product.id!,
          productName: product.name,
          sellingPrice: product.sellingPrice,
          totalFixedCost: totalFixedCost,
          totalVariableCost: totalVariableCost,
          totalUnitsSold: totalUnitsSold,
          totalRevenue: totalRevenue,
          profitLoss: profitLoss,
          isProfit: profitLoss >= 0,
        ));
      }

      products.value = allProducts;
      productSummaries.value = summaries;
      logger.info('Product summaries loaded: ${summaries.length}');
    } catch (e) {
      logger.error('Error loading product summaries', e);
    }
  }

  // Get summary for specific product
  ProductSummary? getProductSummary(int productId) {
    try {
      return productSummaries.firstWhere((s) => s.productId == productId);
    } catch (e) {
      logger.error('Error getting product summary', e);
      return null;
    }
  }

  // Refresh dashboard
  Future<void> refreshDashboard() async {
    await loadDashboard();
  }

  // Get total costs
  double getTotalCosts() {
    return overallSummary.value?.totalCosts ?? 0;
  }

  // Get total revenue
  double getTotalRevenue() {
    return overallSummary.value?.totalRevenue ?? 0;
  }

  // Get profit/loss
  double getProfitLoss() {
    return overallSummary.value?.profitLoss ?? 0;
  }

  // Check if overall profitable
  bool isOverallProfitable() {
    return overallSummary.value?.isOverallProfit ?? false;
  }

  // Get BEP target progress percentage
  Future<double> getBepProgressPercentage() async {
    try {
      final totalRevenue = await saleRepository.getTotalAllRevenue();
      final totalCosts = await costRepository.getTotalAllCosts();

      if (totalCosts == 0) return 0;
      return (totalRevenue / totalCosts) * 100;
    } catch (e) {
      logger.error('Error calculating BEP progress', e);
      return 0;
    }
  }

  // Get top performing products
  List<ProductSummary> getTopProducts({int limit = 3}) {
    try {
      final sorted = [...productSummaries];
      sorted.sort((a, b) => b.profitLoss.compareTo(a.profitLoss));
      return sorted.take(limit).toList();
    } catch (e) {
      logger.error('Error getting top products', e);
      return [];
    }
  }

  // Get profitable products count
  int getProfitableProductsCount() {
    try {
      return productSummaries.where((p) => p.isProfit).length;
    } catch (e) {
      logger.error('Error counting profitable products', e);
      return 0;
    }
  }

  // Get total BEP units for all products
  double getTotalBepUnits() {
    try {
      double totalBepUnits = 0;

      // Iterate through all products and calculate BEP for each
      for (int i = 0; i < products.length; i++) {
        final product = products[i];
        if (i >= productSummaries.length) break;

        final summary = productSummaries[i];

        // Calculate variable cost per unit
        final variableCostPerUnit = summary.totalUnitsSold > 0
            ? (summary.totalVariableCost / summary.totalUnitsSold)
            : 0.0;

        // Calculate contribution margin
        final contribution = product.sellingPrice - variableCostPerUnit;

        // Only calculate BEP if contribution is positive
        if (contribution > 0) {
          final bepUnit = summary.totalFixedCost / contribution;
          if (bepUnit > 0) {
            totalBepUnits += bepUnit;
          }
        }
      }

      return totalBepUnits;
    } catch (e) {
      logger.error('Error getting total BEP units', e);
      return 0;
    }
  }

  // Get total units sold for all products
  double getTotalUnitsSold() {
    try {
      double totalUnits = 0;
      for (var summary in productSummaries) {
        totalUnits += summary.totalUnitsSold;
      }
      return totalUnits;
    } catch (e) {
      logger.error('Error getting total units sold', e);
      return 0;
    }
  }
}
