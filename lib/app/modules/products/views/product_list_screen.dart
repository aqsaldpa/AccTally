import 'dart:async';
import 'package:acctally/app/data/controllers/product_controller.dart';
import 'package:acctally/app/data/models/product_model.dart';
import 'package:acctally/app/modules/products/views/product_detail_screen.dart';
import 'package:acctally/app/shared/widgets/custom_app_bar.dart';
import 'package:acctally/core/constants/app_constants.dart';
import 'package:acctally/core/utils/flushbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class ProductListScreen extends GetView<ProductController> {
  const ProductListScreen({super.key});

  void showAddBottomSheet(BuildContext context) {
    final nameCtrl = TextEditingController();
    final sellingPriceCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'addProduct'.tr,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(20.h),
                Text(
                  'name'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(8.h),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
                Gap(16.h),
                Text(
                  'sellingPrice'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(8.h),
                TextField(
                  controller: sellingPriceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: 'RM ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
                Gap(24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      try {
                        final name = nameCtrl.text;
                        final sellingPrice = double.parse(
                          sellingPriceCtrl.text.isEmpty
                              ? '0'
                              : sellingPriceCtrl.text,
                        );

                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('nameRequired'.tr)),
                          );
                          return;
                        }

                        final now = DateTime.now().millisecondsSinceEpoch;
                        final newProduct = ProductModel(
                          name: name,
                          unit: 'unit',
                          sellingPrice: sellingPrice,
                          fixedCost: 0,
                          variableCost: 0,
                          createdAt: now,
                          updatedAt: now,
                        );
                        controller.createProduct(newProduct);
                        Navigator.pop(context);
                        Future.delayed(const Duration(milliseconds: 300), () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('productAdded'.tr)),
                          );
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('invalidInput'.tr)),
                        );
                      }
                    },
                    child: Text('saveButton'.tr),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showEditBottomSheet(BuildContext context, ProductModel product) {
    final nameCtrl = TextEditingController(text: product.name);
    final sellingPriceCtrl = TextEditingController(
      text: product.sellingPrice.toString(),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'editProduct'.tr,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(20.h),
                Text(
                  'name'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(8.h),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
                Gap(16.h),
                Text(
                  'sellingPrice'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(8.h),
                TextField(
                  controller: sellingPriceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: 'RM ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
                Gap(24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      try {
                        final name = nameCtrl.text;
                        final sellingPrice = double.parse(
                          sellingPriceCtrl.text.isEmpty
                              ? '0'
                              : sellingPriceCtrl.text,
                        );

                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('nameRequired'.tr)),
                          );
                          return;
                        }

                        final now = DateTime.now().millisecondsSinceEpoch;
                        final updatedProduct = product.copyWith(
                          name: name,
                          sellingPrice: sellingPrice,
                          updatedAt: now,
                        );
                        controller.updateProduct(updatedProduct);
                        Navigator.pop(context);
                        Future.delayed(const Duration(milliseconds: 300), () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('productUpdated'.tr)),
                          );
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('invalidInput'.tr)),
                        );
                      }
                    },
                    child: Text('saveButton'.tr),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showDeleteDialog(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text(
          'deleteProduct'.tr,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        content: Text(
          '${'deleteConfirmation'.tr} "${product.name}"?',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'cancel'.tr,
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteProduct(product.id!);
              Navigator.pop(context);
              // Show flushbar after dialog closes
              Future.delayed(const Duration(milliseconds: 300), () {
                flush.showSuccess('productDeleted'.tr);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'delete'.tr,
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(title: 'product'.tr),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 80.sp,
                  color: Colors.grey.shade300,
                ),
                Gap(20.h),
                Text(
                  'noProductsAdded'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(8.h),
                Text(
                  'addYourFirstProduct'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade400,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gap(32.h),
                ElevatedButton.icon(
                  onPressed: () => showAddBottomSheet(context),
                  icon: const Icon(Icons.add),
                  label: Text('addProduct'.tr),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'listProduct'.tr,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12.r),
                    onTap: () => showAddBottomSheet(context),
                    child: Padding(
                      padding: EdgeInsets.all(12.r),
                      child: Iconify(AppConstants.iconPlus, size: 20.sp),
                    ),
                  ),
                ],
              ),
              Gap(20.h),
              Expanded(
                child: ListView.separated(
                  itemCount: controller.products.length,
                  separatorBuilder: (context, index) => Gap(12.h),
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: () {
                          // Navigate to product detail screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailScreen(productId: product.id),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      product.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    Gap(6.h),
                                    Text(
                                      'tapToViewDetails'.tr,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Gap(12.w),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        onTap: () => showEditBottomSheet(
                                          context,
                                          product,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.r),
                                          child: Icon(
                                            Icons.edit_outlined,
                                            color: Colors.blue.shade600,
                                            size: 20.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Gap(8.w),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFEF4444,
                                      ).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        onTap: () =>
                                            showDeleteDialog(context, product),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.r),
                                          child: Icon(
                                            Icons.delete,
                                            color: const Color(0xFFEF4444),
                                            size: 20.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
