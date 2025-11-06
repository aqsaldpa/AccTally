import 'package:acctally/app/data/controllers/cost_controller.dart';
import 'package:acctally/app/data/controllers/product_controller.dart';
import 'package:acctally/app/data/controllers/category_controller.dart';
import 'package:acctally/app/data/controllers/bep_controller.dart';
import 'package:acctally/app/data/controllers/dashboard_controller.dart';
import 'package:acctally/app/data/models/cost_entry_model.dart';
import 'package:acctally/app/shared/widgets/custom_app_bar.dart';
import 'package:acctally/app/modules/categories/views/category_list_screen.dart';
import 'package:acctally/app/modules/products/views/product_list_screen.dart';
import 'package:acctally/core/constants/app_colors.dart';
import 'package:acctally/core/utils/flushbar_utils.dart';
import 'package:acctally/core/logger/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EnterCostScreen extends StatefulWidget {
  const EnterCostScreen({super.key});

  @override
  State<EnterCostScreen> createState() => _EnterCostScreenState();
}

class _EnterCostScreenState extends State<EnterCostScreen> {
  late TextEditingController itemNameController;
  late TextEditingController amountController;
  final selectedProductId = Rxn<int>();
  final selectedCategoryId = Rxn<int>();
  late CostController costController;
  late ProductController productCtrl;

  @override
  void initState() {
    super.initState();
    itemNameController = TextEditingController();
    amountController = TextEditingController();
    costController = Get.find<CostController>();
    productCtrl = Get.find<ProductController>();
  }

  @override
  void dispose() {
    itemNameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void saveCostEntry() {
    if (itemNameController.text.isEmpty ||
        amountController.text.isEmpty ||
        selectedProductId.value == null ||
        selectedCategoryId.value == null) {
      flush.showError('pleaseCheckAllFields'.tr);
      return;
    }

    try {
      final amount = double.parse(amountController.text);
      final now = DateTime.now().millisecondsSinceEpoch;

      final entry = CostEntryModel(
        productId: selectedProductId.value!,
        categoryId: selectedCategoryId.value!,
        itemName: itemNameController.text,
        amount: amount,
        costDate: now,
        createdAt: now,
        updatedAt: now,
        notes: '',
      );

      costController.createCostEntry(entry);
      itemNameController.clear();
      amountController.clear();
      selectedCategoryId.value = null;
      // Keep selectedProductId to show updated summary
      // selectedProductId.value = null;

      flush.showSuccess('costEntryAdded'.tr);

      // Refresh BEP and Dashboard data
      _refreshRelatedData();
    } catch (e) {
      flush.showError('invalidAmount'.tr);
    }
  }

  Future<void> _refreshRelatedData() async {
    try {
      // Refresh Dashboard controller first
      try {
        final dashboardController = Get.find<DashboardController>();
        await dashboardController.loadDashboard();
      } catch (e) {
        logger.error('Dashboard controller not found', e);
      }

      // Then refresh BEP controller
      try {
        final bepController = Get.find<BepController>();
        await bepController.calculateAllBepResults();
      } catch (e) {
        logger.error('BEP controller not found', e);
      }
    } catch (e) {
      logger.error('Error refreshing related data', e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // Refresh dashboard when returning to home
          Future.delayed(const Duration(milliseconds: 500), () async {
            await _refreshRelatedData();
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: CustomAppBar(title: 'enterCostTitle'.tr),
        body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'addNewCost'.tr,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(16.h),
                    // Product Dropdown
                    Text(
                      'selectProduct'.tr,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                    Gap(8.h),
                    Obx(() {
                      if (productCtrl.products.isEmpty) {
                        return ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProductListScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: Text('addProduct'.tr),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[700],
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          ),
                        );
                      }
                      return DropdownButtonFormField<int>(
                        initialValue: selectedProductId.value,
                        hint: Text(
                          'select'.tr,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        items: productCtrl.products.map((product) {
                          return DropdownMenuItem(
                            value: product.id,
                            child: Text(product.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedProductId.value = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      );
                    }),
                    Gap(12.h),
                    // Category Dropdown with Manage button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'category'.tr,
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            // Navigate to category list
                            Get.to(() => const CategoryListScreen());
                          },
                          icon: Icon(Icons.settings, size: 16.sp),
                          label: Text('manage'.tr, style: TextStyle(fontSize: 12.sp)),
                        ),
                      ],
                    ),
                    Gap(8.h),
                    Obx(() {
                      final categoryCtrl = Get.find<CategoryController>();
                      if (categoryCtrl.categories.isEmpty) {
                        return Text(
                          'noCategoriesAdded'.tr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        );
                      }
                      return DropdownButtonFormField<int>(
                        initialValue: selectedCategoryId.value,
                        hint: Text(
                          'selectCategory'.tr,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        items: categoryCtrl.categories.map((category) {
                          return DropdownMenuItem(
                            value: category.id,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedCategoryId.value = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      );
                    }),
                    Gap(12.h),
                    Text(
                      'itemName'.tr,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                    Gap(8.h),
                    TextField(
                      controller: itemNameController,
                      decoration: InputDecoration(
                        hintText: 'hintItemName'.tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    Gap(12.h),
                    Text(
                      'amount'.tr,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                    Gap(8.h),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixText: 'RM ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    Gap(16.h),
                    ValueListenableBuilder(
                      valueListenable: amountController,
                      builder: (context, value, _) {
                        final amount = double.tryParse(amountController.text) ?? 0.0;
                        return Text(
                          '${'total'.tr}: ${'currency'.tr} ${amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Gap(16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveCostEntry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 16.h,
                  ),
                ),
                child: Text(
                  'addCost'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Gap(24.h),
            Text(
              'costSummary'.tr,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            Gap(16.h),
            Obx(() {
              if (costController.costEntries.isEmpty) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 56.sp,
                          color: Colors.grey[300],
                        ),
                        Gap(12.h),
                        Center(
                          child: Text(
                            'noCostEntries'.tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Gap(4.h),
                        Center(
                          child: Text(
                            'startAddingCostsToTrack'.tr,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Filter entries by selected product
              final filteredEntries = selectedProductId.value == null
                  ? <CostEntryModel>[]
                  : costController.costEntries
                      .where((e) => e.productId == selectedProductId.value)
                      .toList();

              if (filteredEntries.isEmpty && selectedProductId.value != null) {
                return Text(
                  'noCostEntriesForProduct'.tr,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                );
              }

              if (selectedProductId.value == null) {
                return Text(
                  'selectProductToViewSummary'.tr,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                );
              }

              // Lookup category names
              final categoryCtrl = Get.find<CategoryController>();
              final Map<int, String> categoryMap = {};
              for (var cat in categoryCtrl.categories) {
                categoryMap[cat.id!] = cat.name;
              }

              // Calculate total for filtered entries
              double filteredTotal = 0;
              for (var entry in filteredEntries) {
                filteredTotal += entry.amount;
              }

              return Card(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'itemName'.tr,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'category'.tr,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'amount'.tr,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                            ),
                          ),
                        ],
                      ),
                      Gap(12.h),
                      ...filteredEntries.map((entry) {
                        final categoryName = categoryMap[entry.categoryId] ?? 'Unknown';
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  entry.itemName,
                                  style: TextStyle(fontSize: 13.sp),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  categoryName,
                                  style: TextStyle(fontSize: 13.sp),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '${'currency'.tr} ${entry.amount.toStringAsFixed(2)}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 13.sp),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      Gap(12.h),
                      const Divider(height: 16),
                      Padding(
                        padding: EdgeInsets.only(top: 6.h),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(''),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'total'.tr,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${'currency'.tr} ${filteredTotal.toStringAsFixed(2)}',
                                textAlign: TextAlign.right,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      ),
    );
  }
}
