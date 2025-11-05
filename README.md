# 📊 AccTally - Aplikasi Analisis BEP & Penjualan

Aplikasi Flutter untuk mengelola biaya produk, data penjualan, dan menghitung Break Even Point (BEP) dengan clean architecture MVVM.

## 🚀 Quick Start

```bash
# Install dependencies
flutter pub get

# Jalankan aplikasi
flutter run
```

## 📂 Struktur Project

```
acctally/
├── lib/
│   ├── main.dart                    ← Entry point (initialization)
│   ├── app/
│   │   ├── app.dart                 ← Main app widget
│   │   ├── screens/
│   │   │   └── home_screen.dart     ← Home / Dashboard
│   │   ├── modules/                 ← Feature modules (expandable)
│   │   │   └── cost/
│   │   │       ├── models/
│   │   │       ├── repositories/
│   │   │       ├── controllers/
│   │   │       └── views/
│   │   └── shared/
│   │       └── theme/
│   └── core/
│       ├── database/
│       ├── logger/
│       ├── preferences/
│       ├── localization/
│       ├── constants/
│       └── utils/
│
├── assets/                          ← Images, Icons, Fonts
│   ├── images/
│   │   ├── app_logo.png
│   │   ├── splash_screen.png
│   │   ├── illustration_empty.png
│   │   └── illustration_error.png
│   ├── icons/
│   │   ├── ic_cost.png
│   │   ├── ic_sales.png
│   │   ├── ic_bep.png
│   │   └── ic_analysis.png
│   └── fonts/                       ← Optional: Custom fonts
│       ├── Poppins-Regular.ttf
│       ├── Poppins-Bold.ttf
│       └── Poppins-SemiBold.ttf
│
├── android/
├── ios/
├── web/
├── pubspec.yaml                     ← Assets configured ✓
└── README.md
```

## 🛠️ Teknologi yang Digunakan

| Package | Versi | Fungsi |
|---------|-------|--------|
| sqflite | ^2.3.0 | SQLite database lokal |
| shared_preferences | ^2.2.2 | Penyimpanan preferensi user |
| logger | ^2.0.0 | Developer logging |
| get | ^4.6.6 | State management & navigation |
| intl | ^0.19.0 | Formatting & localization |
| another_flushbar | ^1.12.29 | Beautiful notifications |

## 💾 Database

### Tabel: costs
Menyimpan informasi biaya produk untuk perhitungan BEP.

```
id                INTEGER PRIMARY KEY
name              TEXT (nama produk/layanan)
fixedCost         REAL (biaya tetap)
variableCostPerUnit REAL (biaya variabel per unit)
sellingPrice      REAL (harga jual per unit)
unit              TEXT (satuan: piece, kg, liter, dll)
createdAt         INTEGER (timestamp)
updatedAt         INTEGER (timestamp)
```

**Rumus BEP:**
```
BEP = fixedCost / (sellingPrice - variableCostPerUnit)
```

### Tabel: sales
Menyimpan data penjualan yang terkait dengan produk.

```
id              INTEGER PRIMARY KEY
costId          INTEGER FOREIGN KEY → costs(id)
quantity        INTEGER (jumlah unit terjual)
saleDate        INTEGER (tanggal penjualan)
totalRevenue    REAL (total pendapatan)
createdAt       INTEGER (timestamp)
updatedAt       INTEGER (timestamp)
```

## 📝 Cara Menggunakan

### 1. Logger
Gunakan logger untuk semua output debug (JANGAN gunakan print()):

```dart
import 'package:acctally/core/logger/app_logger.dart';

logger.debug('Informasi debug');
logger.info('Informasi penting');
logger.warning('Peringatan');
logger.error('Terjadi error', exception);
logger.trace('Trace detail');
```

### 1.1 Logger Utils
Helper methods untuk logging yang lebih terstruktur:

```dart
import 'package:acctally/core/utils/logger_utils.dart';

// API Call
LoggerUtils.logApiCall('GET', '/api/costs', {'filter': 'active'});
// Output: API: GET /api/costs | {filter: active}

// Database Operation
LoggerUtils.logDbOperation('INSERT', 'costs', 1);
// Output: DB: INSERT on costs | Records: 1

// UI Event
LoggerUtils.logUiEvent('CostListView', 'Add Cost Button Pressed', 'opened form');
// Output: UI: [CostListView] Add Cost Button Pressed | opened form

// Performance Tracking
final start = DateTime.now();
// ... do something ...
final duration = DateTime.now().difference(start);
LoggerUtils.logPerformance('Load costs', duration);
// Output: Performance: Load costs completed in 250ms

// Feature Usage
LoggerUtils.logFeatureUsage('BEP Calculation');
// Output: Feature used: BEP Calculation

// Error with Context
try {
  // ... operation ...
} catch (e, st) {
  LoggerUtils.logErrorWithContext('CostRepository', 'Failed to load costs', e, st);
  // Output: [CostRepository] Failed to load costs
}
```

### 2. SharedPreferences
Simpan preferensi user:

```dart
import 'package:acctally/core/preferences/app_preferences.dart';

// Simpan
await preferences.setString('currency', 'IDR');
await preferences.setBool('isDarkMode', true);
await preferences.setInt('userId', 123);

// Ambil
String? currency = preferences.getString('currency');
bool? isDark = preferences.getBool('isDarkMode');
int? userId = preferences.getInt('userId');

// Hapus
await preferences.remove('currency');
```

### 3. Database - CRUD Operations

**Buat (Create):**
```dart
final repository = CostRepository();
final cost = CostModel(
  name: 'Kopi Premium',
  fixedCost: 2000000.0,
  variableCostPerUnit: 5000.0,
  sellingPrice: 15000.0,
  unit: 'cup',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
final id = await repository.insertCost(cost);
logger.info('Biaya ditambahkan dengan ID: $id');
```

**Baca (Read):**
```dart
// Semua data
final allCosts = await repository.getAllCosts();

// Satu data by ID
final cost = await repository.getCostById(1);

// Query custom
final database = databaseInit.database;
final maps = await database.query(
  'costs',
  where: 'name LIKE ?',
  whereArgs: ['%Kopi%'],
);
```

**Ubah (Update):**
```dart
final updatedCost = cost.copyWith(
  sellingPrice: 20000.0,
  updatedAt: DateTime.now(),
);
await repository.updateCost(updatedCost);
flush.showSuccess('Biaya berhasil diperbarui');
```

**Hapus (Delete):**
```dart
await repository.deleteCost(costId);
flush.showSuccess('Biaya berhasil dihapus');
```

### 4. Notifications (Flushbar)

```dart
import 'package:acctally/core/utils/flushbar_utils.dart';

// Success notification
flush.showSuccess('Data berhasil disimpan');
flush.showSuccess('Data berhasil disimpan', title: 'Sukses');

// Error notification
flush.showError('Terjadi kesalahan');

// Info notification
flush.showInfo('Informasi penting');

// Warning notification
flush.showWarning('Perhatian: data belum lengkap');

// Loading notification
flush.showLoading('Sedang memproses...');

// Dismiss notification
flush.dismiss();
```

### 5. State Management (GetX)

```dart
import 'package:get/get.dart';

class MyController extends GetxController {
  final items = <String>[].obs;  // Reactive variable
  final isLoading = false.obs;

  void addItem(String item) {
    items.add(item);  // Auto-update UI
  }
}

// Dalam widget
class MyView extends StatelessWidget {
  final controller = Get.put(MyController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView(
      children: controller.items.map((item) => Text(item)).toList(),
    ));
  }
}
```

## 📋 Membuat Feature Baru

### Step 1: Buat Folder
```bash
mkdir -p lib/app/modules/feature_name/{models,repositories,controllers,views}
```

### Step 2: Model
File: `lib/app/modules/feature_name/models/feature_model.dart`

```dart
class FeatureModel {
  final int? id;
  final String name;
  final DateTime createdAt;

  FeatureModel({
    this.id,
    required this.name,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'createdAt': createdAt.millisecondsSinceEpoch,
  };

  factory FeatureModel.fromMap(Map<String, dynamic> map) => FeatureModel(
    id: map['id'],
    name: map['name'],
    createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
  );
}
```

### Step 3: Repository
File: `lib/app/modules/feature_name/repositories/feature_repository.dart`

```dart
import 'package:sqflite/sqflite.dart';
import 'package:acctally/core/database/database_init.dart';
import 'package:acctally/core/logger/app_logger.dart';
import '../models/feature_model.dart';

class FeatureRepository {
  final Database _db = databaseInit.database;

  Future<int> insert(FeatureModel item) async {
    try {
      final id = await _db.insert('features', item.toMap());
      logger.debug('Feature inserted: $id');
      return id;
    } catch (e) {
      logger.error('Error insert feature', e);
      rethrow;
    }
  }

  Future<List<FeatureModel>> getAll() async {
    try {
      final maps = await _db.query('features', orderBy: 'createdAt DESC');
      return maps.map((m) => FeatureModel.fromMap(m)).toList();
    } catch (e) {
      logger.error('Error get features', e);
      rethrow;
    }
  }

  Future<int> update(FeatureModel item) async {
    try {
      final updated = await _db.update(
        'features',
        item.toMap(),
        where: 'id = ?',
        whereArgs: [item.id],
      );
      logger.debug('Feature updated');
      return updated;
    } catch (e) {
      logger.error('Error update feature', e);
      rethrow;
    }
  }

  Future<int> delete(int id) async {
    try {
      final deleted = await _db.delete(
        'features',
        where: 'id = ?',
        whereArgs: [id],
      );
      logger.debug('Feature deleted');
      return deleted;
    } catch (e) {
      logger.error('Error delete feature', e);
      rethrow;
    }
  }
}
```

### Step 4: Controller
File: `lib/app/modules/feature_name/controllers/feature_controller.dart`

```dart
import 'package:get/get.dart';
import 'package:acctally/core/logger/app_logger.dart';
import 'package:acctally/core/utils/flushbar_utils.dart';
import '../models/feature_model.dart';
import '../repositories/feature_repository.dart';

class FeatureController extends GetxController {
  final _repository = FeatureRepository();

  final items = <FeatureModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadItems();
  }

  Future<void> loadItems() async {
    try {
      isLoading.value = true;
      items.assignAll(await _repository.getAll());
      logger.info('Loaded ${items.length} items');
    } catch (e) {
      logger.error('Error load items', e);
      flush.showError('Gagal memuat data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addItem(FeatureModel item) async {
    try {
      isLoading.value = true;
      await _repository.insert(item);
      await loadItems();
      logger.info('Item added');
      flush.showSuccess('Data berhasil ditambahkan');
    } catch (e) {
      logger.error('Error add item', e);
      flush.showError('Gagal menambahkan data');
    } finally {
      isLoading.value = false;
    }
  }
}
```

### Step 5: View
File: `lib/app/modules/feature_name/views/feature_view.dart`

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/feature_controller.dart';

class FeatureView extends StatelessWidget {
  final controller = Get.put(FeatureController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Features')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.items.isEmpty) {
          return Center(
            child: Text('Tidak ada data',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            final item = controller.items[index];
            return ListTile(
              title: Text(item.name),
              subtitle: Text(item.createdAt.toString()),
            );
          },
        );
      }),
    );
  }
}
```

## 🗄️ Tambah Database Table

Edit `lib/core/database/database_init.dart`:

```dart
Future<void> createTables(Database db) async {
  await createCostsTable(db);
  await createSalesTable(db);
  await createFeatureTable(db);  // ← Tambah baris ini
}

Future<void> createFeatureTable(Database db) async {
  await db.execute('''
    CREATE TABLE features (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT,
      createdAt INTEGER NOT NULL
    )
  ''');
  logger.debug('features table created');
}
```

## ✨ Best Practices

✓ **Gunakan logger** - Jangan pakai print()
✓ **Pakai flush** - Untuk notifikasi user
✓ **Package imports** - Gunakan `import 'package:acctally/...';`
✓ **Try-catch** - Untuk semua operasi database
✓ **Reactive UI** - Pakai `.obs` dan `Obx()`
✓ **Constants** - Define di `app_constants.dart`
✓ **Separation** - Business logic di controller, UI di view
✗ **Jangan underscore** - Function: `calculateBEP()` bukan `_calculateBEP()`

### 6. Localization (Multi-Bahasa)

Aplikasi mendukung English (EN) dan Malay (MS):

```dart
import 'package:acctally/core/localization/localization_service.dart';

// Gunakan di widget
Text('costTitle'.tr)  // Tampil "Costs" atau "Kos" sesuai bahasa

// Atau dengan full key access
Text(LocalizationService.get('costTitle'))

// Ganti bahasa
await LocalizationService.setLanguage('ms');  // Ganti ke Malay
await LocalizationService.setLanguage('en');  // Ganti ke English

// Current locale
final currentLocale = LocalizationService.currentLocale;
```

**Localization Keys:** Semua keys tersedia di:
- `lib/core/localization/en.dart` - English translations
- `lib/core/localization/ms.dart` - Malay translations

**Contoh Text EN vs MS:**

| Key | English | Malay |
|-----|---------|-------|
| `'btnAdd'.tr` | "Add" | "Tambah" |
| `'btnSave'.tr` | "Save" | "Simpan" |
| `'costTitle'.tr` | "Costs" | "Kos" |
| `'costAddSuccess'.tr` | "Cost added successfully" | "Kos berhasil ditambahkan" |
| `'errorLoadingData'.tr` | "Error loading data" | "Ralat memuatkan data" |

**Full Widget Example dengan EN & MS:**

```dart
class CostFormView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('costAddNew'.tr),  // EN: "Add New Cost" | MS: "Tambah Kos Baru"
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'costProductName'.tr,  // EN: "Product Name" | MS: "Nama Produk"
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            // Product Name Input
            TextField(
              decoration: InputDecoration(
                hintText: 'costProductName'.tr,
                labelText: 'costProductName'.tr,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Fixed Cost Label
            Text(
              'costFixedCost'.tr,  // EN: "Fixed Cost" | MS: "Kos Tetap"
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            // Fixed Cost Input
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '0.00',
                labelText: 'costFixedCost'.tr,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Variable Cost Label
            Text(
              'costVariableCost'.tr,  // EN: "Variable Cost per Unit" | MS: "Kos Berubah per Unit"
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            // Variable Cost Input
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '0.00',
                labelText: 'costVariableCost'.tr,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Selling Price Label
            Text(
              'costSellingPrice'.tr,  // EN: "Selling Price" | MS: "Harga Jual"
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            // Selling Price Input
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '0.00',
                labelText: 'costSellingPrice'.tr,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveCost,
                child: Text('btnSave'.tr),  // EN: "Save" | MS: "Simpan"
              ),
            ),

            const SizedBox(height: 8),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.back(),
                child: Text('btnCancel'.tr),  // EN: "Cancel" | MS: "Batal"
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveCost() {
    flush.showSuccess('costAddSuccess'.tr);  // EN: "Cost added successfully" | MS: "Kos berhasil ditambahkan"
    LoggerUtils.logUiEvent('CostForm', 'Save Cost', 'form submitted');
  }
}
```

**Output ketika Language EN:**
```
Title: "Add New Cost"
Labels: "Product Name", "Fixed Cost", "Variable Cost per Unit", "Selling Price"
Buttons: "Save", "Cancel"
Success Message: "Cost added successfully"
```

**Output ketika Language MS:**
```
Title: "Tambah Kos Baru"
Labels: "Nama Produk", "Kos Tetap", "Kos Berubah per Unit", "Harga Jual"
Buttons: "Simpan", "Batal"
Success Message: "Kos berhasil ditambahkan"
```

**Menambah Translation Baru:**
1. Buka `lib/core/localization/en.dart`
2. Tambah key: `'myNewKey': 'English text'`
3. Buka `lib/core/localization/ms.dart`
4. Tambah key dengan EXACT SAME KEY: `'myNewKey': 'Malay text'`
5. Gunakan di widget: `'myNewKey'.tr`

**PENTING:** Keys harus sama persis di en.dart dan ms.dart!

## 🎯 Prinsip Arsitektur

### MVVM Pattern
- **Model** - Data structures (CostModel)
- **ViewModel** - Business logic (CostController)
- **View** - UI components (CostListView)
- **Repository** - Data access layer (CostRepository)

### Clean Code
- No underscore prefixes
- Meaningful variable names
- Proper error handling
- Comprehensive logging
- Clear separation of concerns

## 📚 File Penting

| File | Tujuan |
|------|--------|
| `lib/main.dart` | App initialization |
| `lib/app/screens/home_screen.dart` | Home/dashboard |
| `lib/core/database/database_init.dart` | Database setup |
| `lib/core/logger/app_logger.dart` | Logging system |
| `lib/core/utils/flushbar_utils.dart` | Notifications |
| `lib/app/modules/cost/` | Reference MVVM module |

## 🔧 Troubleshooting

**Import error?**
→ Pastikan pakai package imports: `import 'package:acctally/...';`

**Database error?**
→ Check `lib/main.dart` - database auto-initialize

**State tidak update?**
→ Gunakan `.obs` untuk variables dan `Obx()` untuk widgets

**Need notification?**
→ Gunakan `flush.showSuccess()`, `flush.showError()`, dll

## 📞 Kontak & Support

Untuk pertanyaan atau issue, lihat file-file project lebih detail, khususnya Cost module sebagai referensi.

---

**Happy Coding!** 💻🚀

v0.1.0

## 📱 Android Permissions (AndroidManifest.xml)

Aplikasi sudah dikonfigurasi dengan permissions untuk database dan asset management:

```xml
<!-- Database & Storage Permissions -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

<!-- Asset & File Management Permissions -->
<uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.ACCESS_MEDIA_LOCATION" />
```

**Untuk Android 11+ (API 30+):**
- `MANAGE_EXTERNAL_STORAGE` - Full file system access
- `ACCESS_MEDIA_LOCATION` - Access media location metadata

**Penggunaan di Code:**
```dart
// Request permission saat runtime (Android 6+)
import 'package:permission_handler/permission_handler.dart';

Future<void> requestStoragePermission() async {
  final status = await Permission.storage.request();
  if (status.isGranted) {
    logger.info('Storage permission granted');
  } else {
    logger.warning('Storage permission denied');
  }
}
```


## 🎨 Assets Management

### Folder Structure
```
assets/
├── images/          → App images, illustrations, splash screens
├── icons/           → App icons, menu icons
└── fonts/           → Optional: Custom fonts
```

### Konfigurasi di pubspec.yaml
```yaml
flutter:
  assets:
    # Entire folder
    - assets/images/
    - assets/icons/
    
    # Specific files
    - assets/images/app_logo.png
    - assets/images/splash_screen.png
    - assets/images/illustration_empty.png
    - assets/images/illustration_error.png
    
    # Icons
    - assets/icons/ic_cost.png
    - assets/icons/ic_sales.png
    - assets/icons/ic_bep.png
    - assets/icons/ic_analysis.png
```

### Cara Menggunakan

**1. Load Image:**
```dart
import 'package:flutter/material.dart';

Image.asset('assets/images/app_logo.png')

// Dengan ukuran
Image.asset(
  'assets/images/app_logo.png',
  width: 200,
  height: 200,
  fit: BoxFit.contain,
)

// Di Button
ElevatedButton.icon(
  onPressed: () {},
  icon: Image.asset('assets/icons/ic_cost.png', width: 24, height: 24),
  label: Text('Add Cost'),
)
```

**2. Load Icon:**
```dart
// PNG Icon
Icon(Icons.add)  // Built-in

// Custom PNG Icon
SizedBox(
  width: 32,
  height: 32,
  child: Image.asset('assets/icons/ic_cost.png'),
)
```

**3. Background Image:**
```dart
Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/background.png'),
      fit: BoxFit.cover,
    ),
  ),
  child: ...,
)
```

**4. Splash Screen Image:**
```dart
Scaffold(
  body: Center(
    child: Image.asset(
      'assets/images/splash_screen.png',
      fit: BoxFit.contain,
    ),
  ),
)
```

**5. Empty State Illustration:**
```dart
if (data.isEmpty) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/illustration_empty.png',
          width: 200,
          height: 200,
        ),
        SizedBox(height: 16),
        Text('No data available'),
      ],
    ),
  );
}
```

### Image Optimization Tips

1. **Gunakan PNG untuk icons** (transparent background)
2. **Gunakan WebP untuk images** (lebih kecil size)
3. **Asset size max ~100KB** untuk kecepatan load
4. **Gunakan lazy loading** untuk images yang besar

### Optional: Custom Fonts

Uncomment di pubspec.yaml dan add .ttf files:
```yaml
fonts:
  - family: Poppins
    fonts:
      - asset: assets/fonts/Poppins-Regular.ttf
      - asset: assets/fonts/Poppins-Bold.ttf
        weight: 700
      - asset: assets/fonts/Poppins-SemiBold.ttf
        weight: 600
```

Gunakan di code:
```dart
Text(
  'Hello World',
  style: TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    fontSize: 18,
  ),
)
```

### Asset Sizing Chart

| Purpose | Size | Format |
|---------|------|--------|
| App Logo | 192x192 | PNG |
| Icon | 48x48 | PNG |
| Splash Screen | 1080x1920 | WebP |
| Illustration | 400x400 | PNG/WebP |
| Background | 1080x1920 | WebP |

---


## 🎨 Google Fonts - Poppins Integration

Aplikasi menggunakan **Google Fonts Poppins** untuk typography yang modern dan konsisten di seluruh app.

### Setup (Sudah Configured ✓)

**Dependencies:**
```yaml
dependencies:
  google_fonts: ^6.1.0
```

**Theme Integration:**
Semua TextTheme di `lib/app/shared/theme/app_theme.dart` sudah menggunakan `GoogleFonts.poppins()`.

### Cara Menggunakan

**1. Basic Text dengan Default Theme:**
```dart
// Otomatis pakai Poppins dari TextTheme
Text(
  'Hello World',
  style: Theme.of(context).textTheme.headlineSmall,  // Poppins, w600, 18px
)

Text(
  'Welcome',
  style: Theme.of(context).textTheme.bodyMedium,  // Poppins, normal, 14px
)
```

**2. Custom Poppins dengan Specific Weight:**
```dart
import 'package:google_fonts/google_fonts.dart';

Text(
  'AccTally',
  style: GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w700,  // Bold
    color: Colors.blue,
  ),
)
```

**3. Poppins dengan berbagai Weight:**
```dart
// Light (300)
Text('Light Text', style: GoogleFonts.poppins(fontWeight: FontWeight.w300))

// Regular (400)
Text('Regular Text', style: GoogleFonts.poppins(fontWeight: FontWeight.w400))

// Medium (500)
Text('Medium Text', style: GoogleFonts.poppins(fontWeight: FontWeight.w500))

// SemiBold (600)
Text('SemiBold Text', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))

// Bold (700)
Text('Bold Text', style: GoogleFonts.poppins(fontWeight: FontWeight.w700))

// ExtraBold (800)
Text('ExtraBold Text', style: GoogleFonts.poppins(fontWeight: FontWeight.w800))
```

**4. TextField dengan Poppins:**
```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Product Name',
    labelStyle: GoogleFonts.poppins(
      color: Colors.grey,
      fontWeight: FontWeight.w500,
    ),
    hintText: 'Enter product name',
    hintStyle: GoogleFonts.poppins(
      color: Colors.grey[400],
    ),
  ),
)
```

**5. Button dengan Poppins:**
```dart
ElevatedButton(
  onPressed: () {},
  child: Text(
    'Save',
    style: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
)
```

**6. AppBar Title dengan Poppins:**
```dart
AppBar(
  title: Text(
    'Cost Management',
    style: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
)
```

### TextTheme Reference (Built-in Poppins)

```
displayLarge    → 32px, Bold (w700)      → Untuk heading utama
displayMedium   → 28px, Bold (w700)      → Untuk heading
displaySmall    → 24px, Bold (w700)      → Untuk sub-heading
                
headlineMedium  → 20px, Bold (w700)      → Untuk title besar
headlineSmall   → 18px, SemiBold (w600)  → Untuk title
                
titleLarge      → 16px, SemiBold (w600)  → Untuk section title
titleMedium     → 14px, Medium (w500)    → Untuk subtitle
titleSmall      → 12px, Medium (w500)    → Untuk small subtitle
                
bodyLarge       → 16px, Regular (w400)   → Untuk body text panjang
bodyMedium      → 14px, Regular (w400)   → Untuk body text normal
bodySmall       → 12px, Regular (w400)   → Untuk small text
```

### Font Weights Available

| Weight | Name | Usage |
|--------|------|-------|
| w300 | Light | Highlight, secondary info |
| w400 | Regular | Body text, paragraphs |
| w500 | Medium | Labels, subtle emphasis |
| w600 | SemiBold | Titles, section headers |
| w700 | Bold | Headlines, emphasis |
| w800 | ExtraBold | Major headings |

### Performance Tips

✓ Google Fonts automatically caches fonts on device
✓ No need to include .ttf files in assets
✓ Fonts download automatically on first use
✓ Already optimized by Google

### Example Widget dengan Poppins

```dart
class CostCard extends StatelessWidget {
  final String name;
  final double price;

  const CostCard({required this.name, required this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title dengan Poppins Bold
            Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            // Price dengan Poppins SemiBold
            Text(
              'Rp ${price.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 12),
            // Button dengan Poppins Medium
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Edit',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

