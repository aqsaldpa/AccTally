import 'dart:async';
import 'package:acctally/app/data/controllers/category_controller.dart';
import 'package:acctally/app/data/models/category_model.dart';
import 'package:acctally/app/shared/widgets/custom_app_bar.dart';
import 'package:acctally/app/shared/widgets/item_editor_bottom_sheet.dart';
import 'package:acctally/core/constants/app_constants.dart';
import 'package:acctally/core/utils/flushbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class CategoryListScreen extends GetView<CategoryController> {
  const CategoryListScreen({super.key});

  void showAddBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => ItemEditorBottomSheet(
        title: 'addCategories'.tr,
        includeCostType: true,
        onSave: (name, costType) {
          if (costType == null) return; // guarded by widget
          final now = DateTime.now().millisecondsSinceEpoch;
          final newCategory = CategoryModel(
            name: name,
            costType: costType,
            createdAt: now,
            updatedAt: now,
          );
          controller.createCategory(newCategory);
          Navigator.pop(context);
          // Show flushbar after bottom sheet closes
          Future.delayed(const Duration(milliseconds: 300), () {
            flush.showSuccess('categoryAdded'.tr);
          });
        },
      ),
    );
  }

  void showEditBottomSheet(BuildContext context, CategoryModel category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => ItemEditorBottomSheet(
        title: 'editCategories'.tr,
        initialName: category.name,
        includeCostType: true,
        initialCostType: category.costType,
        onSave: (name, costType) {
          if (costType == null) return; // guarded by widget
          final now = DateTime.now().millisecondsSinceEpoch;
          final updatedCategory = category.copyWith(
            name: name,
            costType: costType,
            updatedAt: now,
          );
          controller.updateCategory(updatedCategory);
          Navigator.pop(context);
          // Show flushbar after bottom sheet closes
          Future.delayed(const Duration(milliseconds: 300), () {
            flush.showSuccess('categoryUpdated'.tr);
          });
        },
      ),
    );
  }

  void showDeleteDialog(BuildContext context, CategoryModel category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text(
          'deleteCategory'.tr,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        content: Text(
          '${'deleteConfirmation'.tr} "${category.name}"?',
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
              controller.deleteCategory(category.id!);
              Navigator.pop(context);
              // Show flushbar after dialog closes
              Future.delayed(const Duration(milliseconds: 300), () {
                flush.showSuccess('categoryDeleted'.tr);
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
      appBar: CustomAppBar(title: 'categories'.tr),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.categories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 80.sp,
                  color: Colors.grey.shade300,
                ),
                Gap(20.h),
                Text(
                  'noCategoriesAdded'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(8.h),
                Text(
                  'createYourFirstCategory'.tr,
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
                  label: Text('addCategory'.tr),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
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
                    'listCategories'.tr,
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
                  itemCount: controller.categories.length,
                  separatorBuilder: (context, index) => Gap(12.h),
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
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
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      category.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    Gap(6.h),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6.r),
                                      ),
                                      child: Text(
                                        category.costType.label,
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.blue.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
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
                                        borderRadius: BorderRadius.circular(8.r),
                                        onTap: () => showEditBottomSheet(context, category),
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
                                      color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(8.r),
                                        onTap: () => showDeleteDialog(context, category),
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
