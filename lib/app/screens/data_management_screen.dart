import 'package:acctally/app/modules/categories/views/category_list_screen.dart';
import 'package:acctally/app/modules/products/views/product_list_screen.dart';
import 'package:acctally/app/shared/widgets/custom_app_bar.dart';
import 'package:acctally/core/constants/app_colors.dart';
import 'package:acctally/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class DataManagementScreen extends StatefulWidget {
  const DataManagementScreen({super.key});

  @override
  State<DataManagementScreen> createState() => _DataManagementScreenState();
}

class _DataManagementScreenState extends State<DataManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'dataManagement'.tr),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200.w,
              child: cardProductHorizontal(AppConstants.iconProduct, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductListScreen(),
                  ),
                );
              }, 'products'.tr),
            ),
            Gap(15),
            SizedBox(
              width: 200.w,
              child: cardProductHorizontal(AppConstants.iconCategories, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoryListScreen(),
                  ),
                );
              }, 'categories'.tr),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardProductHorizontal(String icon, VoidCallback onTap, String title) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: AppColors.lightBlueColor,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Iconify(icon, color: AppColors.primaryColor, size: 50),
              Gap(15),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
