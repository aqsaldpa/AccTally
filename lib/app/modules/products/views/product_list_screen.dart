import 'package:acctally/app/modules/products/views/product_detail_screen.dart';
import 'package:acctally/app/shared/widgets/custom_app_bar.dart';
import 'package:acctally/app/shared/widgets/item_editor_bottom_sheet.dart';
import 'package:acctally/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => ProductListScreenState();
}

class ProductListScreenState extends State<ProductListScreen> {
  final List<String> products = List.generate(10, (i) => 'Nasi $i');

  void showAddBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => ItemEditorBottomSheet(
        title: 'addProduct'.tr,
        onSave: (name, _) {
          setState(() => products.add(name));
        },
      ),
    );
  }

  void showEditBottomSheet(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => ItemEditorBottomSheet(
        title: 'editProduct'.tr,
        initialName: products[index],
        onSave: (name, _) {
          setState(() => products[index] = name);
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
          'deleteProduct'.tr,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        content: Text(
          '${'deleteConfirmation'.tr} "${products[index]}"?',
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
              setState(() => products.removeAt(index));
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
      appBar: CustomAppBar(title: 'product'.tr),
      body: Padding(
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
                itemCount: products.length,
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
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(13.r),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    products[index],
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
