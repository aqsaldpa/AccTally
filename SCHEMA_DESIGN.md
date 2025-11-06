# AccTally - Complete Database Schema Design

## 📊 Database Architecture Overview

```
AccTally Database (sqflite)
├── Products Table
├── Categories Table
├── Cost Entries Table
├── Sale Entries Table
└── Calculations (Derived, not stored)
```

## 🗄️ Table Schemas

### 1. **products** Table
Stores all products with their cost and pricing information.

```sql
CREATE TABLE products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  unit TEXT NOT NULL DEFAULT 'unit',
  selling_price REAL NOT NULL,        -- Price per unit
  fixed_cost REAL NOT NULL DEFAULT 0,  -- Monthly/periodic fixed cost
  variable_cost REAL NOT NULL DEFAULT 0, -- Variable cost per unit
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
)
```

**Fields:**
- `id`: Unique identifier
- `name`: Product name (e.g., "Nasi Ayam")
- `unit`: Measurement unit (e.g., "pcs", "kg")
- `selling_price`: Selling price per unit (RM)
- `fixed_cost`: Fixed cost for this product (e.g., stall rent)
- `variable_cost`: Variable cost per unit produced/sold (e.g., ingredients)
- `created_at`, `updated_at`: Timestamps

**Indexes:**
- PRIMARY KEY on `id`
- UNIQUE INDEX on `name`

---

### 2. **categories** Table
Stores cost categories (Raw Materials, Direct Labor, Overhead, etc.)

```sql
CREATE TABLE categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  cost_type TEXT NOT NULL CHECK(cost_type IN ('fixed', 'variable')),
  description TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
)
```

**Fields:**
- `id`: Unique identifier
- `name`: Category name (e.g., "Raw Materials", "Direct Labor")
- `cost_type`: 'fixed' or 'variable'
- `created_at`, `updated_at`: Timestamps

**Indexes:**
- PRIMARY KEY on `id`
- UNIQUE INDEX on `name`

---

### 3. **cost_entries** Table
Stores individual cost entries for each product.

```sql
CREATE TABLE cost_entries (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,
  category_id INTEGER NOT NULL,
  item_name TEXT NOT NULL,
  amount REAL NOT NULL,
  cost_date INTEGER NOT NULL,
  notes TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE,
  FOREIGN KEY(category_id) REFERENCES categories(id) ON DELETE RESTRICT
)
```

**Fields:**
- `id`: Unique identifier
- `product_id`: Reference to product
- `category_id`: Reference to category (Raw Materials, Labor, etc.)
- `item_name`: Name of the cost item (e.g., "Oil", "Worker Salary")
- `amount`: Amount in RM
- `cost_date`: Date of the cost entry
- `notes`: Additional notes
- `created_at`, `updated_at`: Timestamps

**Indexes:**
- PRIMARY KEY on `id`
- FOREIGN KEY on `product_id`
- FOREIGN KEY on `category_id`
- INDEX on `cost_date` (for date range queries)

---

### 4. **sale_entries** Table
Stores individual sale/transaction records.

```sql
CREATE TABLE sale_entries (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL,
  unit_price REAL NOT NULL,
  total_revenue REAL NOT NULL,
  sale_date INTEGER NOT NULL,
  notes TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE
)
```

**Fields:**
- `id`: Unique identifier
- `product_id`: Reference to product
- `quantity`: Number of units sold
- `unit_price`: Selling price per unit at time of sale
- `total_revenue`: quantity × unit_price
- `sale_date`: Date of sale
- `notes`: Additional notes
- `created_at`, `updated_at`: Timestamps

**Indexes:**
- PRIMARY KEY on `id`
- FOREIGN KEY on `product_id`
- INDEX on `sale_date` (for date range queries)

---

## 📐 Relationships Diagram

```
products (1) ──→ (Many) cost_entries
           │
           └──→ (Many) sale_entries

categories (1) ──→ (Many) cost_entries
```

**Relationships:**
- **1-to-Many:** One Product has many Cost Entries
- **1-to-Many:** One Product has many Sale Entries
- **1-to-Many:** One Category has many Cost Entries

---

## 🧮 Calculated Fields (NOT stored in DB)

### For Each Product:

1. **Total Fixed Cost**
   ```
   SELECT SUM(amount) FROM cost_entries
   WHERE product_id = ? AND category_id IN (
     SELECT id FROM categories WHERE cost_type = 'fixed'
   )
   ```

2. **Total Variable Cost**
   ```
   SELECT SUM(amount) FROM cost_entries
   WHERE product_id = ? AND category_id IN (
     SELECT id FROM categories WHERE cost_type = 'variable'
   )
   ORDER BY cost_date DESC LIMIT 1  -- Latest entry
   ```

3. **Total Units Sold**
   ```
   SELECT SUM(quantity) FROM sale_entries WHERE product_id = ?
   ```

4. **Total Revenue**
   ```
   SELECT SUM(total_revenue) FROM sale_entries WHERE product_id = ?
   ```

5. **Break-Even Point (BEP) in Units**
   ```
   BEP = Total Fixed Cost / (Selling Price - Variable Cost per Unit)
   ```

6. **Profit/Loss**
   ```
   Profit/Loss = (Units Sold × Selling Price) - Total Fixed Cost - (Units Sold × Variable Cost per Unit)
   Status = if(Units Sold >= BEP) then "PROFIT" else "LOSS"
   ```

7. **Overall Summary (All Products)**
   ```
   Total Costs = SUM(all cost_entries)
   Total Sales = SUM(all sale_entries.total_revenue)
   Profit/Loss = Total Sales - Total Costs
   ```

---

## 🔄 Data Flow

```
1. USER ENTERS DATA
   ↓
2. CREATE/UPDATE in SQLite
   ├── Add Product
   ├── Add Cost Entry
   ├── Add Sale Entry
   └── Manage Categories
   ↓
3. READ from SQLite
   ├── List Products
   ├── Get Product Details
   ├── Calculate BEP
   └── Generate Reports
   ↓
4. DISPLAY IN UI
   ├── Home Screen (Overall Summary + BEP Target)
   ├── Product Management
   ├── Cost Entry Screen
   ├── Sales Entry Screen
   ├── BEP Analysis
   └── Reports
```

---

## 📋 CRUD Operations Summary

| Entity | Create | Read | Update | Delete |
|--------|--------|------|--------|--------|
| Product | ✅ | ✅ | ✅ | ✅ |
| Category | ✅ | ✅ | ✅ | ✅ |
| Cost Entry | ✅ | ✅ | ✅ | ✅ |
| Sale Entry | ✅ | ✅ | ✅ | ✅ |

---

## 🔐 Constraints & Validations

### Data Constraints:
1. **Product Name** - UNIQUE, NOT NULL
2. **Category Name** - UNIQUE, NOT NULL
3. **Cost Type** - CHECK constraint (only 'fixed' or 'variable')
4. **Amount Fields** - Must be ≥ 0
5. **Quantity** - Must be > 0
6. **Foreign Keys** - ON DELETE CASCADE for products, ON DELETE RESTRICT for categories

### Application Validations:
1. Product name must not be empty
2. Selling price must be > 0
3. Quantity must be > 0
4. Amount must be > 0
5. Sale date and cost date must be valid
6. Dates must not be in the future (by default)

---

## 🔍 Query Examples

### Get Product with All Costs and Sales:
```sql
SELECT p.*,
       SUM(CASE WHEN c.cost_type = 'fixed' THEN ce.amount ELSE 0 END) as total_fixed_cost,
       SUM(CASE WHEN c.cost_type = 'variable' THEN ce.amount ELSE 0 END) as total_variable_cost,
       SUM(se.quantity) as total_units_sold,
       SUM(se.total_revenue) as total_revenue
FROM products p
LEFT JOIN cost_entries ce ON p.id = ce.product_id
LEFT JOIN categories c ON ce.category_id = c.id
LEFT JOIN sale_entries se ON p.id = se.product_id
WHERE p.id = ?
GROUP BY p.id
```

### Get Overall Summary:
```sql
SELECT
  SUM(ce.amount) as total_costs,
  SUM(se.total_revenue) as total_sales,
  SUM(se.total_revenue) - SUM(ce.amount) as profit_loss
FROM cost_entries ce, sale_entries se
```

### Get Monthly Summary:
```sql
SELECT
  DATE(ce.cost_date / 1000, 'unixepoch') as date,
  SUM(ce.amount) as daily_costs,
  SUM(se.total_revenue) as daily_revenue
FROM cost_entries ce
LEFT JOIN sale_entries se ON DATE(ce.cost_date / 1000, 'unixepoch') =
                              DATE(se.sale_date / 1000, 'unixepoch')
GROUP BY DATE(ce.cost_date / 1000, 'unixepoch')
ORDER BY date DESC
```

---

## 🚀 Implementation Sequence

1. ✅ Update database_init.dart with new schema
2. ✅ Create Models (ProductModel, CategoryModel, CostEntryModel, SaleEntryModel)
3. ✅ Create Repositories (ProductRepository, CategoryRepository, CostRepository, SaleRepository)
4. ✅ Create Controllers/Services for business logic
5. ✅ Update screens to use repositories
6. ✅ Implement BEP calculations
7. ✅ Implement Reports and Overall Summary
8. ✅ Test all CRUD operations

---

## 📝 Notes

- All timestamps stored as milliseconds since epoch (millisecondsSinceEpoch)
- Currency in RM (Malaysian Ringgit)
- SQLite version used: sqflite 2.3.0
- Database file: `acctally.db`
- Supports offline-first architecture
