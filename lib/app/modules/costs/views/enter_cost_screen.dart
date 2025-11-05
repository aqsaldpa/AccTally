import 'package:acctally/app/shared/widgets/custom_app_bar.dart';
import 'package:acctally/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EnterCostScreen extends StatefulWidget {
  const EnterCostScreen({super.key});

  @override
  State<EnterCostScreen> createState() => EnterCostScreenState();
}

class EnterCostScreenState extends State<EnterCostScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String? selectedCategory;

  final List<String> categories = ['Raw Materials', 'Direct Labor', 'Overhead'];

  final List<Map<String, dynamic>> costEntries = [
    {'category': 'Raw Materials', 'amount': 6000},
    {'category': 'Direct Labor', 'amount': 2000},
    {'category': 'Overhead', 'amount': 2000},
  ];

  int get totalCost {
    return costEntries.fold(0, (sum, entry) => sum + (entry['amount'] as int));
  }

  Map<String, int> get categorySummary {
    final Map<String, int> summary = {};
    for (var entry in costEntries) {
      final category = entry['category'] as String;
      final amount = entry['amount'] as int;
      summary[category] = (summary[category] ?? 0) + amount;
    }
    return summary;
  }

  @override
  void dispose() {
    productNameController.dispose();
    itemNameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Text(
                      'productName'.tr,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                    Gap(8.h),
                    TextField(
                      controller: productNameController,
                      decoration: InputDecoration(
                        hintText: 'hintProductName'.tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    Gap(12.h),
                    Text(
                      'category'.tr,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                    Gap(8.h),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      hint: Text(
                        'select'.tr,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
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
                        hintText: 'hintAmount'.tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    Gap(16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${'total'.tr}: ${'currency'.tr} ${amountController.text.isEmpty ? "0" : amountController.text}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 10.h,
                            ),
                          ),
                          child: Text(
                            'addCost'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Gap(24.h),
            Text(
              'costSummary'.tr,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            Gap(16.h),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  children: [
                    Row(
                      children: [
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
                    ...categorySummary.entries.map((entry) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                entry.key,
                                style: TextStyle(fontSize: 13.sp),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${'currency'.tr} ${entry.value}',
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
                            child: Text(
                              'total'.tr,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${'currency'.tr} $totalCost',
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
            ),
          ],
        ),
      ),
    );
  }
}
