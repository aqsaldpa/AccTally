import 'package:acctally/app/shared/widgets/custom_app_bar.dart';
import 'package:acctally/app/shared/widgets/item_editor_bottom_sheet.dart';
import 'package:acctally/app/models/category_item.dart';
import 'package:acctally/app/models/cost_type.dart';
import 'package:acctally/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => CategoryListScreenState();
}

class CategoryListScreenState extends State<CategoryListScreen> {
  final List<CategoryItem> categories = List.generate(
    10,
    (i) => CategoryItem(name: 'Category $i', costType: CostType.variable),
  );

  void showAddBottomSheet() {
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
          setState(() => categories.add(CategoryItem(name: name, costType: costType)));
        },
      ),
    );
  }

  void showEditBottomSheet(int index) {
    final current = categories[index];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => ItemEditorBottomSheet(
        title: 'editCategories'.tr,
        initialName: current.name,
        includeCostType: true,
        initialCostType: current.costType,
        onSave: (name, costType) {
          if (costType == null) return; // guarded by widget
          setState(() {
            categories[index] = CategoryItem(name: name, costType: costType);
          });
        },
      ),
    );
  }

  void showDeleteDialog(int index) {
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
          '${'deleteConfirmation'.tr} "${categories[index].name}"?',
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
              setState(() => categories.removeAt(index));
              Navigator.pop(context);
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
      body: Padding(
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
                  onTap: showAddBottomSheet,
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
                itemCount: categories.length,
                separatorBuilder: (context, index) => Gap(12.h),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(13.r),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    categories[index].name,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1A1A1A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => showEditBottomSheet(index),
                                  child: Icon(
                                    Icons.edit_outlined,
                                    color: Colors.black,
                                    size: 20.sp,
                                  ),
                                ),
                                Gap(10),
                                InkWell(
                                  onTap: () => showDeleteDialog(index),
                                  child: Icon(
                                    Icons.delete,
                                    color: const Color(0xFFEF4444),
                                    size: 20.sp,
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
      ),
    );
  }
}
