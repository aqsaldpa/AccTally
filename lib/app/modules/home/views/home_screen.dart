import 'package:acctally/app/modules/bep/views/bep_analysis_screen.dart';
import 'package:acctally/app/modules/management/views/data_management_screen.dart';
import 'package:acctally/app/modules/costs/views/enter_cost_screen.dart';
import 'package:acctally/app/modules/sales/views/enter_sales_screen.dart';
import 'package:acctally/core/constants/app_colors.dart';
import 'package:acctally/core/constants/app_constants.dart';
import 'package:acctally/core/localization/localization_service.dart';
import 'package:acctally/core/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          backgroundGradient(),
          Positioned(
            top: 40.h,
            right: 20.w,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => changeLanguage(context),
                  borderRadius: BorderRadius.circular(8.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.language,
                          color: AppColors.primaryColor,
                          size: 24.sp,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          LocalizationService.getCurrentLanguageCode()
                              .toUpperCase(),
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 70.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  greetingSection(),
                  bepTargetSection(),
                  overallSummarySection(),
                  dataSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void changeLanguage(BuildContext context) {
    final currentLang = LocalizationService.getCurrentLanguageCode();
    final currentLanguageName = LocalizationService.getCurrentLanguage();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('selectLanguage'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Text(
                '${'current'.tr}: $currentLanguageName',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            ListTile(
              title: Text('english'.tr),
              trailing: currentLang == 'en'
                  ? Icon(Icons.check, color: AppColors.primaryColor)
                  : null,
              selected: currentLang == 'en',
              onTap: currentLang != 'en'
                  ? () {
                      LocalizationService.setLanguage('en');
                      Navigator.pop(context);
                    }
                  : null,
            ),
            ListTile(
              title: Text('bahasaMelayu'.tr),
              trailing: currentLang == 'ms'
                  ? Icon(Icons.check, color: AppColors.primaryColor)
                  : null,
              selected: currentLang == 'ms',
              onTap: currentLang != 'ms'
                  ? () {
                      LocalizationService.setLanguage('ms');
                      Navigator.pop(context);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget greetingSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${'goodGreeting'.tr} ${greeting()}!',
            style: TextStyle(
              color: AppColors.blue,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(30.h),
        ],
      ),
    );
  }

  Widget bepTargetSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'breakEvenPoint'.tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(10.h),
          buildBepTargetCard(),
          Gap(15.h),
        ],
      ),
    );
  }

  Widget buildBepTargetCard() {
    return Card(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.blue[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
        side: BorderSide(color: Colors.blue[300]!, width: 1.w),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(8.0.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'salesVsCost'.tr,
                style: TextStyle(color: AppColors.blue, fontSize: 10.sp),
              ),
              Gap(35.h),
              buildBepTargetProgress(),
              Gap(10.h),
              buildBepTargetStatus(),
              Gap(10.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBepTargetProgress() {
    return Column(
      children: [
        Text(
          'totalBepTarget'.tr,
          style: TextStyle(
            color: AppColors.blue,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gap(10.h),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            LinearProgressIndicator(
              value: 150 / 500,
              borderRadius: BorderRadius.circular(10.r),
              minHeight: 20.h,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
            ),
            Padding(
              padding: EdgeInsets.only(left: (150 / 500) * 327.w),
              child: Container(
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.blue, width: 2.w),
                ),
              ),
            ),
          ],
        ),
        Gap(10.h),
        Text(
          '500/150',
          style: TextStyle(
            color: AppColors.blue,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildBepTargetStatus() {
    return Card(
      color: AppColors.green,
      child: SizedBox(
        child: Padding(
          padding: EdgeInsets.all(8.0.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${'status'.tr} : ${'profit'.tr}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget overallSummarySection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'overallSummary'.tr,
            style: TextStyle(
              color: AppColors.blue,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(15.h),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                summaryCard(
                  title: 'totalCosts'.tr,
                  value: 'RM 500.00',
                  color: AppColors.purplePastel.withValues(alpha: 0.71),
                ),
                summaryCard(
                  title: 'totalSalesAmount'.tr,
                  value: 'RM 500.00',
                  color: AppColors.bluepastel.withValues(alpha: 0.76),
                ),
                summaryCard(
                  title: 'profitLoss'.tr,
                  value: 'RM 500.00',
                  color: AppColors.greenPastel.withValues(alpha: 0.76),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget dataSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(25.h),
          Text(
            'data'.tr,
            style: TextStyle(
              color: AppColors.blue,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dataCard(
                title: 'costs'.tr,
                icon: AppConstants.iconCost,
                onTap: () => handleDataCardTap('costs'),
              ),
              dataCard(
                title: 'sales'.tr,
                icon: AppConstants.iconSales,
                onTap: () => handleDataCardTap('sales'),
              ),
              dataCard(
                title: 'management'.tr,
                icon: AppConstants.iconManagement,
                onTap: () => handleDataCardTap('management'),
              ),
              dataCard(
                title: 'bepAnalysis'.tr,
                icon: AppConstants.iconBEPAnalysis,
                onTap: () => handleDataCardTap('bepAnalysis'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void handleDataCardTap(String title) {
    switch (title) {
      case 'costs':
        Navigator.push(
          Get.context!,
          MaterialPageRoute(builder: (context) => const EnterCostScreen()),
        );
        break;
      case 'sales':
        Navigator.push(
          Get.context!,
          MaterialPageRoute(builder: (context) => const EnterSalesScreen()),
        );
        break;
      case 'management':
        Navigator.push(
          Get.context!,
          MaterialPageRoute(builder: (context) => const DataManagementScreen()),
        );
        break;
      case 'bepAnalysis':
        Navigator.push(
          Get.context!,
          MaterialPageRoute(builder: (context) => const BepAnalysisScreen()),
        );
        break;
    }
  }

  Widget dataCard({
    required String title,
    required String icon,
    required VoidCallback onTap,
  }) {
    return Flexible(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Material(
              borderRadius: BorderRadius.circular(12.r),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(12.r),
                splashColor: AppColors.blue.withValues(alpha: 0.2),
                highlightColor: AppColors.blue.withValues(alpha: 0.1),
                child: Card(
                  color: AppColors.lightBlueColor,
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 10.h,
                    ),
                    child: Iconify(
                      icon,
                      color: AppColors.primaryColor,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Gap(8.h),
          Text(
            title,
            style: TextStyle(
              color: AppColors.blue,
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget summaryCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Flexible(
      child: SizedBox(
        width: double.infinity,
        child: Card(
          color: color,
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 25.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max, // Tambahkan ini
              children: [
                Text(
                  title,
                  textAlign:
                      TextAlign.center, // Tambahkan ini untuk center text
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Gap(10.h),
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget backgroundGradient() {
    return Container(
      height: 250.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.gradientColorBluePrimary,
            AppColors.gradientColorBlueSecondary,
          ],
          stops: [0.13, 10],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}
