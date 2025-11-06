import 'package:acctally/app/data/controllers/cost_controller.dart';
import 'package:acctally/app/data/controllers/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CostReportScreen extends GetView<CostController> {
  final int? productId;

  const CostReportScreen({super.key, this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Obx(() {
        if (controller.costEntries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 80.sp,
                  color: Colors.grey.shade300,
                ),
                Gap(20.h),
                Text(
                  'noCostEntries'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(8.h),
                Text(
                  'startAddingCostsToTrack'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Filter entries by product if productId is provided
        final filteredEntries = productId == null
            ? controller.costEntries
            : controller.costEntries
                  .where((e) => e.productId == productId)
                  .toList();

        if (filteredEntries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.filter_alt_off_outlined,
                  size: 80.sp,
                  color: Colors.grey.shade300,
                ),
                Gap(20.h),
                Text(
                  'noCostEntriesForProduct'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(8.h),
                Text(
                  'noRecordsForSelectedFilter'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Calculate totals by category
        final Map<String, double> categoryTotals = {};
        double grandTotal = 0;

        for (var entry in filteredEntries) {
          final categoryId = entry.categoryId;
          categoryTotals[categoryId.toString()] =
              (categoryTotals[categoryId.toString()] ?? 0) + entry.amount;
          grandTotal += entry.amount;
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Card
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'totalCosts'.tr,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${'currency'.tr} ${grandTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(20.h),
              // Cost Entries List
              Text(
                'costDetails'.tr,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              Gap(12.h),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'itemName'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'category'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'amount'.tr,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 20.h),
                      // Entries
                      ...filteredEntries.map((entry) {
                        final categoryCtrl = Get.find<CategoryController>();
                        // Find category name from database
                        final category = categoryCtrl.categories
                            .firstWhereOrNull((c) => c.id == entry.categoryId);
                        final categoryName = category?.name ?? 'Unknown';

                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  entry.itemName,
                                  style: TextStyle(fontSize: 13.sp),
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
                                flex: 2,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
