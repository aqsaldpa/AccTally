import 'package:acctally/app/shared/widgets/custom_app_bar.dart';
import 'package:acctally/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EnterSalesScreen extends StatefulWidget {
  const EnterSalesScreen({super.key});

  @override
  State<EnterSalesScreen> createState() => EnterSalesScreenState();
}

class EnterSalesScreenState extends State<EnterSalesScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  final List<Map<String, dynamic>> salesEntries = [
    {'product': 'Nasi Ayam', 'unit': 500, 'price': 20, 'total': 10000},
    {'product': 'Nasi Lemak', 'unit': 100, 'price': 20, 'total': 2000},
  ];

  int get totalSales {
    return salesEntries.fold(0, (sum, entry) => sum + (entry['total'] as int));
  }

  int calculateTotal() {
    final price = int.tryParse(priceController.text) ?? 0;
    final quantity = int.tryParse(quantityController.text) ?? 0;
    return price * quantity;
  }

  @override
  void initState() {
    super.initState();
    priceController.addListener(() => setState(() {}));
    quantityController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    productNameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'price'.tr,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                    Gap(8.h),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'hintPrice'.tr,
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
                      decoration: InputDecoration(
                        hintText: 'hintQuantity'.tr,
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
                          '${'total'.tr}: ${'currency'.tr} ${calculateTotal()}',
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
                            'addSale'.tr,
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
              'salesSummary'.tr,
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
                          flex: 3,
                          child: Text(
                            'productName'.tr,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'unit'.tr,
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
                    ...salesEntries.map((entry) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                entry['product'],
                                style: TextStyle(fontSize: 13.sp),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                entry['unit'].toString(),
                                style: TextStyle(fontSize: 13.sp),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${'currency'.tr} ${entry['total']}',
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
                            child: Text(
                              'total'.tr,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(''),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${'currency'.tr} $totalSales',
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
