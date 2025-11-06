# AccTally - Complete Implementation Guide

## Status: Database Layer ✅ In Progress

### Phase 1: Database & Models ✅ COMPLETED
- [x] Database schema updated (database_init.dart)
- [x] ProductModel created
- [x] CategoryModel created
- [x] CostEntryModel created
- [x] SaleEntryModel created
- [x] ProductRepository created

### Phase 2: Repositories (IN PROGRESS)
Need to create:
- [ ] CategoryRepository (CREATE, READ, UPDATE, DELETE, get all)
- [ ] CostEntryRepository (CREATE, READ, UPDATE, DELETE, get by product, get by date range)
- [ ] SaleEntryRepository (CREATE, READ, UPDATE, DELETE, get by product, get by date range)
- [ ] AnalyticsRepository (calculated fields - BEP, totals, summaries)

### Phase 3: Controllers/Services (PENDING)
Need to create:
- [ ] ProductController (manage products)
- [ ] CostController (manage cost entries, summaries)
- [ ] SalesController (manage sale entries, summaries)
- [ ] BepController (BEP calculations)
- [ ] DashboardController (overall summary)

### Phase 4: UI Integration (PENDING)
Update screens to use:
- [ ] ProductListScreen → ProductRepository
- [ ] ProductDetailScreen → Analytics
- [ ] EnterCostScreen → CostRepository
- [ ] EnterSalesScreen → SaleRepository
- [ ] BepAnalysisScreen → BepController
- [ ] HomeScreen → DashboardController

## Quick Reference: Repository Methods

### ProductRepository
```
✅ createProduct(ProductModel) → int
✅ getAllProducts() → List<ProductModel>
✅ getProductById(int) → ProductModel?
✅ getProductByName(String) → ProductModel?
✅ updateProduct(ProductModel) → int
✅ deleteProduct(int) → int
✅ getProductCount() → int
✅ productExists(String) → bool
```

### CategoryRepository (TODO)
```
createCategory(CategoryModel) → int
getAllCategories() → List<CategoryModel>
getCategoryById(int) → CategoryModel?
getCategoryByName(String) → CategoryModel?
updateCategory(CategoryModel) → int
deleteCategory(int) → int
getByType(CostType) → List<CategoryModel>
```

### CostEntryRepository (TODO)
```
createCostEntry(CostEntryModel) → int
getAllCostEntries() → List<CostEntryModel>
getCostEntriesForProduct(int productId) → List<CostEntryModel>
getCostEntriesByDateRange(int from, int to) → List<CostEntryModel>
getCostEntriesByCategory(int categoryId) → List<CostEntryModel>
updateCostEntry(CostEntryModel) → int
deleteCostEntry(int) → int
getTotalCostForProduct(int productId) → double
```

### SaleEntryRepository (TODO)
```
createSaleEntry(SaleEntryModel) → int
getAllSaleEntries() → List<SaleEntryModel>
getSaleEntriesForProduct(int productId) → List<SaleEntryModel>
getSaleEntriesByDateRange(int from, int to) → List<SaleEntryModel>
updateSaleEntry(SaleEntryModel) → int
deleteSaleEntry(int) → int
getTotalRevenueForProduct(int productId) → double
getTotalUnitsForProduct(int productId) → int
```

### AnalyticsRepository (TODO)
```
getBepForProduct(int productId) → BepResult
getProductSummary(int productId) → ProductSummary
getOverallSummary() → OverallSummary
getMonthlySummary(int year, int month) → MonthlySummary
getProductProfitLoss(int productId) → double
getAllProductsSummary() → List<ProductSummary>
```

## Data Models Needed

```dart
class BepResult {
  double bepUnit;
  bool isProfit;
  double unitsSoldAboveBep;
  double profitAmount;
  String status;
}

class ProductSummary {
  ProductModel product;
  double totalFixedCost;
  double totalVariableCost;
  int totalUnitsSold;
  double totalRevenue;
  double profitLoss;
  BepResult bepResult;
}

class OverallSummary {
  double totalCosts;
  double totalRevenue;
  double totalProfitLoss;
  int totalProducts;
  int totalSales;
}

class MonthlySummary {
  int month;
  int year;
  double totalCosts;
  double totalRevenue;
  double profitLoss;
}
```

## Integration Sequence

1. **First**: Complete all repositories
2. **Second**: Create controllers/services
3. **Third**: Create result models (BepResult, ProductSummary, etc.)
4. **Fourth**: Update home_screen.dart to use DashboardController
5. **Fifth**: Update product management screens
6. **Sixth**: Update cost/sales entry screens
7. **Seventh**: Update BEP analysis screen
8. **Eighth**: Test entire flow

## Database Query Examples (For Reference)

### Get Product with Total Costs
```sql
SELECT p.*,
  SUM(CASE WHEN c.cost_type = 'fixed' THEN ce.amount ELSE 0 END) as total_fixed_cost,
  SUM(CASE WHEN c.cost_type = 'variable' THEN ce.amount ELSE 0 END) as total_variable_cost
FROM products p
LEFT JOIN cost_entries ce ON p.id = ce.product_id
LEFT JOIN categories c ON ce.category_id = c.id
WHERE p.id = ?
GROUP BY p.id
```

### Get Overall Summary
```sql
SELECT
  SUM(ce.amount) as total_costs,
  SUM(se.total_revenue) as total_sales,
  SUM(se.total_revenue) - SUM(ce.amount) as profit_loss
FROM cost_entries ce, sale_entries se
```

### Get BEP for Product
```
Total Fixed Cost = SUM(amount) WHERE category.cost_type = 'fixed'
Variable Cost per Unit = Latest cost_entry WHERE category.cost_type = 'variable'
BEP = Total Fixed Cost / (Selling Price - Variable Cost per Unit)
```

## Next Steps

The repository pattern provides:
- ✅ Clean separation of concerns
- ✅ Testable code
- ✅ Easy to modify database logic
- ✅ Reusable methods across app
- ✅ Type safety with models

Once all repositories are complete, controllers will orchestrate business logic and UI will just call controllers.
