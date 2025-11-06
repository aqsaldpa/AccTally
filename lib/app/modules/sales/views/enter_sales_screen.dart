import 'package:acctally/app/data/controllers/sales_controller.dart';
import 'package:acctally/app/data/controllers/product_controller.dart';
import 'package:acctally/app/data/controllers/bep_controller.dart';
import 'package:acctally/app/data/controllers/dashboard_controller.dart';
import 'package:acctally/app/data/models/sale_entry_model.dart';
import 'package:acctally/app/shared/widgets/custom_app_bar.dart';
import 'package:acctally/app/modules/products/views/product_list_screen.dart';
import 'package:acctally/core/constants/app_colors.dart';
import 'package:acctally/core/utils/flushbar_utils.dart';
import 'package:acctally/core/logger/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EnterSalesScreen extends StatefulWidget {
  const EnterSalesScreen({super.key});

  @override
  State<EnterSalesScreen> createState() => _EnterSalesScreenState();
}

class _EnterSalesScreenState extends State<EnterSalesScreen> {
  late TextEditingController priceController;
  late TextEditingController quantityController;
  final totalCalculator = RxDouble(0);
  final selectedProductId = Rxn<int>();
  late SalesController salesController;
  late ProductController productCtrl;

  @override
  void initState() {
    super.initState();
    priceController = TextEditingController();
    quantityController = TextEditingController();
    salesController = Get.find<SalesController>();
    productCtrl = Get.find<ProductController>();
  }

  @override
  void dispose() {
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  void updateTotal() {
    try {
      final price = double.parse(priceController.text);
      final quantity = int.parse(quantityController.text);
      totalCalculator.value = price * quantity;
    } catch (e) {
      totalCalculator.value = 0;
    }
  }

  void saveSaleEntry() {
    if (priceController.text.isEmpty ||
        quantityController.text.isEmpty ||
        selectedProductId.value == null) {
      flush.showError('pleaseCheckAllFields'.tr);
      return;
    }

    try {
      final unitPrice = double.parse(priceController.text);
      final quantity = int.parse(quantityController.text);
      final totalRevenue = unitPrice * quantity;
      final now = DateTime.now().millisecondsSinceEpoch;

      final entry = SaleEntryModel(
        productId: selectedProductId.value!,
        quantity: quantity,
        unitPrice: unitPrice,
        totalRevenue: totalRevenue,
        saleDate: now,
        createdAt: now,
        updatedAt: now,
      );

      salesController.createSaleEntry(entry);
      priceController.clear();
      quantityController.clear();
      totalCalculator.value = 0;
      selectedProductId.value = null;

      flush.showSuccess('saleEntryAdded'.tr);

      // Refresh BEP and Dashboard data
      _refreshRelatedData();
    } catch (e) {
      flush.showError('invalidInput'.tr);
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
        appBar: CustomAppBar(title: 'enterSalesTitle'.tr),
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
                      'addNewSales'.tr,
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
                        onChanged: (value) async {
                          selectedProductId.value = value;
                          // Auto-fill price from product
                          if (value != null) {
                            final product = await productCtrl.getProductById(value);
                            if (product != null) {
                              priceController.text = product.sellingPrice.toString();
                              updateTotal();
                            }
                          }
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
                      'price'.tr,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                    Gap(8.h),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => updateTotal(),
                      decoration: InputDecoration(
                        prefixText: 'RM ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    Gap(12.h),
                    Text(
                      'quantity'.tr,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                    Gap(8.h),
                    TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => updateTotal(),
                      decoration: InputDecoration(
                        hintText: 'hintQuantity'.tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    Gap(16.h),
                    Obx(() {
                      return Text(
                        '${'total'.tr}: ${'currency'.tr} ${totalCalculator.value.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Gap(16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveSaleEntry,
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
                  'addSale'.tr,
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
              'salesSummary'.tr,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            Gap(16.h),
            Obx(() {
              if (salesController.saleEntries.isEmpty) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      children: [
                        Icon(
                          Icons.point_of_sale_outlined,
                          size: 56.sp,
                          color: Colors.grey[300],
                        ),
                        Gap(12.h),
                        Center(
                          child: Text(
                            'noSalesEntries'.tr,
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
                            'startAddingSalesToTrack'.tr,
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
                  ? <SaleEntryModel>[]
                  : salesController.saleEntries
                      .where((e) => e.productId == selectedProductId.value)
                      .toList();

              if (filteredEntries.isEmpty && selectedProductId.value != null) {
                return Text(
                  'noSalesEntriesForProduct'.tr,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                );
              }

              if (selectedProductId.value == null) {
                return Text(
                  'selectProductToViewSummary'.tr,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                );
              }

              return Card(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'product'.tr,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'quantity'.tr,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'total'.tr,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                            ),
                          ),
                        ],
                      ),
                      Gap(12.h),
                      ...filteredEntries.map((entry) {
                        // Lookup product name
                        final product = productCtrl.products
                            .firstWhereOrNull((p) => p.id == entry.productId);
                        final productName = product?.name ?? 'Unknown';

                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  productName,
                                  style: TextStyle(fontSize: 13.sp),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  entry.quantity.toString(),
                                  style: TextStyle(fontSize: 13.sp),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${'currency'.tr} ${entry.totalRevenue.toStringAsFixed(2)}',
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
                              flex: 3,
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
                              flex: 2,
                              child: Text(
                                '${'currency'.tr} ${salesController.totalRevenue.value.toStringAsFixed(2)}',
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
