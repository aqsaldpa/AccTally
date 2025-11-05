import 'package:acctally/app/modules/costs/views/cost_report_screen.dart';
import 'package:acctally/app/modules/sales/views/sales_report_screen.dart';
import 'package:acctally/app/shared/widgets/custom_app_bar.dart';
import 'package:acctally/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'productNasiAyam'.tr),
      body: Column(
        children: [
          ColoredBox(
            color: Colors.grey.shade200,
            child: TabBar(
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.5),
              ),
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              labelStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
              unselectedLabelStyle: TextStyle(
                color: Colors.black.withValues(alpha: 0.75),
                fontWeight: FontWeight.normal,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
              tabs: [
                Tab(text: 'costReport'.tr),
                Tab(text: 'salesReport'.tr),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [buildTabContent(0), buildTabContent(1)],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabContent(int index) {
    switch (index) {
      case 0:
        return const Center(child: CostReportScreen());
      case 1:
        return const Center(child: SalesReportScreen());
      default:
        return const SizedBox.shrink();
    }
  }
}
