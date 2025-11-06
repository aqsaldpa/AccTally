class BepResult {
  final int productId;
  final String productName;
  final double sellingPrice;
  final double fixedCost;
  final double variableCost;
  final double bepUnit;
  final int unitsSold;
  final bool isProfit;
  final double unitsAboveBep;
  final double profitLossAmount;
  final double totalRevenue;

  BepResult({
    required this.productId,
    required this.productName,
    required this.sellingPrice,
    required this.fixedCost,
    required this.variableCost,
    required this.bepUnit,
    required this.unitsSold,
    required this.isProfit,
    required this.unitsAboveBep,
    required this.profitLossAmount,
    required this.totalRevenue,
  });

  String get status => isProfit ? 'PROFIT' : 'LOSS';

  double get contribution => sellingPrice - variableCost;

  double get breakEvenPercentage => (unitsSold / bepUnit) * 100;

  @override
  String toString() =>
      'BepResult(product: $productName, BEP: ${bepUnit.toStringAsFixed(2)}, Status: $status)';
}
