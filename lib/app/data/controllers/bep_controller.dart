import 'package:get/get.dart';
import '../models/bep_result.dart';
import '../repositories/product_repository.dart';
import '../repositories/cost_entry_repository.dart';
import '../repositories/sale_entry_repository.dart';
import 'package:acctally/core/logger/app_logger.dart';

class BepController extends GetxController {
  final ProductRepository productRepository;
  final CostEntryRepository costRepository;
  final SaleEntryRepository saleRepository;

  BepController(
    this.productRepository,
    this.costRepository,
    this.saleRepository,
  );

  final bepResults = <BepResult>[].obs;
  final selectedBepResult = Rxn<BepResult>();
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    calculateAllBepResults();
  }

  // Calculate BEP for all products
  Future<void> calculateAllBepResults() async {
    try {
      isLoading.value = true;
      error.value = '';

      final products = await productRepository.getAllProducts();

      if (products.isEmpty) {
        error.value = 'No products found';
        logger.warning('No products available for BEP calculation');
        bepResults.value = [];
        return;
      }

      final results = <BepResult>[];

      for (var product in products) {
        final result = await calculateBepForProduct(product.id!);
        if (result != null) {
          results.add(result);
        }
      }

      bepResults.value = results;
      if (results.isEmpty) {
        logger.warning('No valid BEP results: Check product prices and costs');
      } else {
        logger.info('Calculated BEP for ${results.length} products');
      }
    } catch (e) {
      error.value = 'Failed to calculate BEP: $e';
      logger.error('Error calculating BEP', e);
    } finally {
      isLoading.value = false;
    }
  }

  // Calculate BEP for specific product
  Future<BepResult?> calculateBepForProduct(int productId) async {
    try {
      final product = await productRepository.getProductById(productId);
      if (product == null) {
        logger.warning('Product with ID $productId not found');
        return null;
      }

      final totalFixedCost = await costRepository.getTotalFixedCostForProduct(productId);
      final dynamicVariableCost = await costRepository.getTotalVariableCostForProduct(productId);
      final totalUnitsSold = await saleRepository.getTotalUnitsForProduct(productId);
      final totalRevenue = await saleRepository.getTotalRevenueForProduct(productId);

      // Calculate variable cost per unit (average based on units sold)
      final variableCostPerUnit = totalUnitsSold > 0 ? (dynamicVariableCost / totalUnitsSold).toDouble() : 0.0;

      // BEP = Fixed Cost / (Selling Price - Variable Cost Per Unit)
      final contribution = product.sellingPrice - variableCostPerUnit;
      if (contribution <= 0) {
        logger.warning('Invalid contribution for product ${product.name}: selling price (${product.sellingPrice}) <= variable cost per unit ($variableCostPerUnit)');
        // Still return a result but with special BEP value to indicate issue
        final totalVariableCostActual = totalUnitsSold * variableCostPerUnit;
        final profitLossAmount = totalRevenue - totalFixedCost - totalVariableCostActual;
        return BepResult(
          productId: productId,
          productName: product.name,
          sellingPrice: product.sellingPrice,
          fixedCost: totalFixedCost,
          variableCost: variableCostPerUnit,
          bepUnit: -1, // Special value to indicate invalid pricing
          unitsSold: totalUnitsSold,
          isProfit: false,
          unitsAboveBep: 0,
          profitLossAmount: profitLossAmount,
          totalRevenue: totalRevenue,
        );
      }

      final bepUnit = totalFixedCost / contribution;
      final isProfit = totalUnitsSold >= bepUnit;
      final unitsAboveBep = totalUnitsSold - bepUnit;

      // Profit/Loss = Revenue - (Fixed Cost + Total Variable Cost)
      final totalVariableCostActual = totalUnitsSold * variableCostPerUnit;
      final profitLossAmount = totalRevenue - totalFixedCost - totalVariableCostActual;

      return BepResult(
        productId: productId,
        productName: product.name,
        sellingPrice: product.sellingPrice,
        fixedCost: totalFixedCost,
        variableCost: variableCostPerUnit,
        bepUnit: bepUnit,
        unitsSold: totalUnitsSold,
        isProfit: isProfit,
        unitsAboveBep: unitsAboveBep > 0 ? unitsAboveBep : 0,
        profitLossAmount: profitLossAmount,
        totalRevenue: totalRevenue,
      );
    } catch (e) {
      logger.error('Error calculating BEP for product $productId', e);
      return null;
    }
  }

  // Select product for detailed BEP view
  void selectProduct(BepResult result) {
    selectedBepResult.value = result;
  }

  // Get BEP for specific product
  Future<BepResult?> getBepForProduct(int productId) async {
    try {
      return await calculateBepForProduct(productId);
    } catch (e) {
      logger.error('Error getting BEP for product', e);
      return null;
    }
  }

  // Check if product is profitable
  bool isProductProfitable(int productId) {
    try {
      final result = bepResults.firstWhere(
        (r) => r.productId == productId,
        orElse: () => BepResult(
          productId: productId,
          productName: '',
          sellingPrice: 0,
          fixedCost: 0,
          variableCost: 0,
          bepUnit: 0,
          unitsSold: 0,
          isProfit: false,
          unitsAboveBep: 0,
          profitLossAmount: 0,
          totalRevenue: 0,
        ),
      );
      return result.isProfit;
    } catch (e) {
      logger.error('Error checking profitability', e);
      return false;
    }
  }

  // Get profit amount for product
  Future<double> getProfitAmountForProduct(int productId) async {
    try {
      final result = await calculateBepForProduct(productId);
      return result?.profitLossAmount ?? 0;
    } catch (e) {
      logger.error('Error getting profit amount', e);
      return 0;
    }
  }

  // Refresh all BEP calculations
  Future<void> refreshBepCalculations() async {
    await calculateAllBepResults();
  }
}
