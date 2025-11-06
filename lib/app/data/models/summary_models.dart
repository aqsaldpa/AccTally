class ProductSummary {
  final int productId;
  final String productName;
  final double sellingPrice;
  final double totalFixedCost;
  final double totalVariableCost;
  final int totalUnitsSold;
  final double totalRevenue;
  final double profitLoss;
  final bool isProfit;

  ProductSummary({
    required this.productId,
    required this.productName,
    required this.sellingPrice,
    required this.totalFixedCost,
    required this.totalVariableCost,
    required this.totalUnitsSold,
    required this.totalRevenue,
    required this.profitLoss,
    required this.isProfit,
  });

  @override
  String toString() => 'ProductSummary($productName: ${profitLoss.toStringAsFixed(2)})';
}

class OverallSummary {
  final double totalCosts;
  final double totalRevenue;
  final double profitLoss;
  final int totalProducts;
  final int totalSales;
  final bool isOverallProfit;

  OverallSummary({
    required this.totalCosts,
    required this.totalRevenue,
    required this.profitLoss,
    required this.totalProducts,
    required this.totalSales,
    required this.isOverallProfit,
  });

  @override
  String toString() =>
      'OverallSummary(Revenue: ${totalRevenue.toStringAsFixed(2)}, Costs: ${totalCosts.toStringAsFixed(2)}, Profit: ${profitLoss.toStringAsFixed(2)})';
}

class MonthlySummary {
  final int month;
  final int year;
  final double totalCosts;
  final double totalRevenue;
  final double profitLoss;
  final int transactionCount;

  MonthlySummary({
    required this.month,
    required this.year,
    required this.totalCosts,
    required this.totalRevenue,
    required this.profitLoss,
    required this.transactionCount,
  });

  String get monthYear => '$month/$year';

  @override
  String toString() =>
      'MonthlySummary($monthYear: Revenue ${totalRevenue.toStringAsFixed(2)}, Profit ${profitLoss.toStringAsFixed(2)})';
}
