import 'package:acctally/app/data/controllers/bep_controller.dart';
import 'package:acctally/app/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class BepAnalysisScreen extends GetView<BepController> {
  const BepAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // Refresh BEP data when returning to screen
          Future.delayed(const Duration(milliseconds: 100), () {
            controller.calculateAllBepResults();
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: CustomAppBar(title: 'bepAnalysisTitle'.tr),
        body: Obx(() {
          // Ensure data is loaded on first visit
          if (controller.bepResults.isEmpty && !controller.isLoading.value) {
            controller.calculateAllBepResults();
          }
          // Check if really empty (no products at all)
          if (controller.bepResults.isEmpty && !controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 80.sp,
                    color: Colors.grey.shade300,
                  ),
                  Gap(20.h),
                  Text(
                    'noBepCalculationsYet'.tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Gap(8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Text(
                      'startByAddingProducts'.tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          // Show loading state but keep minimal UI
          if (controller.isLoading.value && controller.bepResults.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Gap(20.h),
                  Text(
                    'processing'.tr,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Show error if calculation failed
          if (controller.error.value.isNotEmpty &&
              controller.bepResults.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80.sp,
                    color: Colors.red.shade300,
                  ),
                  Gap(20.h),
                  Text(
                    'errorCalculatingBep'.tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Gap(8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Text(
                      controller.error.value,
                      style: TextStyle(fontSize: 12.sp, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gap(16.h),
                  ElevatedButton(
                    onPressed: () {
                      controller.calculateAllBepResults();
                    },
                    child: Text('retry'.tr),
                  ),
                ],
              ),
            );
          }

          // Use first result if nothing selected
          final selectedResult =
              controller.selectedBepResult.value ??
              (controller.bepResults.isNotEmpty
                  ? controller.bepResults.first
                  : null);

          if (selectedResult == null) {
            return Center(child: Text('noData'.tr));
          }

          final isProfitable = selectedResult.isProfit;

          return SingleChildScrollView(
            padding: EdgeInsets.all(25.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'selectProduct'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(8.h),
                Obx(() {
                  return DropdownButtonFormField<int>(
                    initialValue: selectedResult.productId,
                    items: controller.bepResults.map((result) {
                      return DropdownMenuItem(
                        value: result.productId,
                        child: Text(result.productName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      final result = controller.bepResults.firstWhere(
                        (r) => r.productId == value,
                      );
                      controller.selectProduct(result);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  );
                }),
                Gap(24.h),
                Card(
                  color: isProfitable
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFE53935),
                  child: Padding(
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      children: [
                        Text(
                          'statusProduct'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Gap(16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isProfitable ? Icons.check_circle : Icons.cancel,
                              color: Colors.white,
                              size: 28.sp,
                            ),
                            Gap(8.w),
                            Text(
                              isProfitable ? 'profit'.tr : 'lossStatus'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Gap(16.h),
                        Text(
                          '${selectedResult.unitsSold} ${'sold'.tr}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                        Gap(12.h),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: LinearProgressIndicator(
                            value:
                                (selectedResult.unitsSold /
                                        (selectedResult.bepUnit * 2))
                                    .clamp(0.0, 1.0),
                            minHeight: 8.h,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.3,
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                        Gap(12.h),
                        Text(
                          '${'totalOf'.tr} ${selectedResult.bepUnit.toStringAsFixed(0)} ${'sold'.tr}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(24.h),
                // Summary Cards - Sales and Cost
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
                                'totalSales'.tr,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                ),
                              ),
                              Gap(8.h),
                              Text(
                                '${'currency'.tr} ${selectedResult.totalRevenue.toStringAsFixed(2)}',
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
                                'totalCosts'.tr,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                ),
                              ),
                              Gap(8.h),
                              Text(
                                '${'currency'.tr} ${selectedResult.fixedCost.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
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
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(
                          builder: (context) {
                            final bepDisplayValue = selectedResult.bepUnit < 0
                                ? 'invalidPricingShort'.tr
                                : '${selectedResult.bepUnit.toStringAsFixed(0)} Unit';

                            return Text(
                              '${'bepUnit'.tr} : $bepDisplayValue',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        Gap(12.h),
                        Builder(
                          builder: (context) {
                            final unitsValue = isProfitable
                                ? selectedResult.unitsAboveBep.toStringAsFixed(
                                    0,
                                  )
                                : (selectedResult.bepUnit -
                                          selectedResult.unitsSold)
                                      .abs()
                                      .toStringAsFixed(0);

                            final message = isProfitable
                                ? 'youHaveSold'.tr.replaceAll(
                                    '{units}',
                                    unitsValue,
                                  )
                                : 'youNeedToSell'.tr.replaceAll(
                                    '{units}',
                                    unitsValue,
                                  );

                            return Text(
                              message,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: const Color(0xFF475569),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(24.h),
                Text(
                  'formulaDetails'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(16.h),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('fixedCost'.tr, style: TextStyle(fontSize: 13.sp)),
                        Text(
                          '${'currency'.tr} ${selectedResult.fixedCost.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(12.h),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'sellingPrice'.tr,
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        Text(
                          '${'currency'.tr} ${selectedResult.sellingPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(12.h),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'variableCost'.tr,
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        Text(
                          '${'currency'.tr} ${selectedResult.variableCost.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(24.h),
                Card(
                  color: isProfitable
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isProfitable ? 'totalProfit'.tr : 'totalLoss'.tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${'currency'.tr} ${selectedResult.profitLossAmount.abs().toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: isProfitable ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(24.h),
              ],
            ),
          );
        }),
      ),
    );
  }
}
