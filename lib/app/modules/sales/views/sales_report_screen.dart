import 'package:acctally/app/data/controllers/sales_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SalesReportScreen extends GetView<SalesController> {
  final int? productId;

  const SalesReportScreen({super.key, this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Obx(() {
        if (controller.saleEntries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.point_of_sale_outlined,
                  size: 80.sp,
                  color: Colors.grey.shade300,
                ),
                Gap(20.h),
                Text(
                  'noSalesEntries'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(8.h),
                Text(
                  'startAddingSalesToTrack'.tr,
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
            ? controller.saleEntries
            : controller.saleEntries
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
                  'noSalesEntriesForProduct'.tr,
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

        // Calculate totals
        double totalRevenue = 0;
        int totalUnits = 0;

        for (var entry in filteredEntries) {
          totalRevenue += entry.totalRevenue;
          totalUnits += entry.quantity;
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'totalUnits'.tr,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                            Gap(8.h),
                            Text(
                              '$totalUnits',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'totalRevenue'.tr,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                            Gap(8.h),
                            Text(
                              '${'currency'.tr} ${totalRevenue.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Gap(24.h),
              // Sales Entries List
              Text(
                'salesDetails'.tr,
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
                            flex: 2,
                            child: Text(
                              'quantity'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'unitPrice'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'totalRevenue'.tr,
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
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Row(
                            children: [
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
                                  '${'currency'.tr} ${entry.unitPrice.toStringAsFixed(2)}',
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
