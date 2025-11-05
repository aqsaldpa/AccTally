import 'package:acctally/app/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class BepAnalysisScreen extends StatefulWidget {
  const BepAnalysisScreen({super.key});

  @override
  State<BepAnalysisScreen> createState() => BepAnalysisScreenState();
}

class BepAnalysisScreenState extends State<BepAnalysisScreen> {
  String selectedProduct = 'Nasi Ayam';

  final List<String> products = ['Nasi Ayam', 'Nasi Lemak', 'Nasi Kuning'];

  final Map<String, Map<String, dynamic>> productData = {
    'Nasi Ayam': {
      'unitSold': 600,
      'bepUnit': 250,
      'fixedCost': 2000,
      'sellingPrice': 20,
      'variableCost': 12,
    },
    'Nasi Lemak': {
      'unitSold': 400,
      'bepUnit': 200,
      'fixedCost': 1500,
      'sellingPrice': 15,
      'variableCost': 8,
    },
    'Nasi Kuning': {
      'unitSold': 300,
      'bepUnit': 180,
      'fixedCost': 1200,
      'sellingPrice': 18,
      'variableCost': 10,
    },
  };

  bool isProfit() {
    final data = productData[selectedProduct]!;
    return data['unitSold'] >= data['bepUnit'];
  }

  int profitLossAmount() {
    final data = productData[selectedProduct]!;
    final contribution = data['sellingPrice'] - data['variableCost'];
    return (data['unitSold'] * contribution) - data['fixedCost'];
  }

  double progressValue() {
    final data = productData[selectedProduct]!;
    return (data['unitSold'] / (data['bepUnit'] * 2)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final data = productData[selectedProduct]!;
    final isProfitable = isProfit();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(title: 'bepAnalysisTitle'.tr),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'selectProduct'.tr,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
            Gap(8.h),
            DropdownButtonFormField<String>(
              initialValue: selectedProduct,
              items: products.map((product) {
                return DropdownMenuItem(
                  value: product,
                  child: Text(product),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProduct = value!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            Gap(24.h),
            Card(
              color: isProfitable ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
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
                          isProfitable ? 'profit'.tr : 'loss'.tr,
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
                      '${data['unitSold']} ${'sold'.tr}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                    Gap(12.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: LinearProgressIndicator(
                        value: progressValue(),
                        minHeight: 8.h,
                        backgroundColor: Colors.white.withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                    Gap(12.h),
                    Text(
                      '${'totalOf'.tr} ${data['bepUnit']} ${'sold'.tr}',
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
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${'bepUnit'.tr} : ${data['bepUnit']} Unit',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(12.h),
                    Text(
                      isProfitable
                          ? 'youHaveSold'.trParams({'units': '${data['unitSold'] - data['bepUnit']}'})
                          : 'youNeedToSell'.trParams({'units': '${data['bepUnit'] - data['unitSold']}'}) ,
                      style: TextStyle(fontSize: 13.sp, color: const Color(0xFF475569)),
                    ),
                  ],
                ),
              ),
            ),
            Gap(24.h),
            Text(
              'formulaDetails'.tr,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            Gap(16.h),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'fixedCost'.tr,
                      style: TextStyle(fontSize: 13.sp),
                    ),
                    Text(
                      'RM ${data['fixedCost']}',
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
                      'RM ${data['sellingPrice']}',
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
                      'RM ${data['variableCost']}',
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
              color: isProfitable ? Colors.green.shade50 : Colors.red.shade50,
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
                      'RM ${profitLossAmount().abs()}',
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
      ),
    );
  }
}
