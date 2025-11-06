import 'package:acctally/app/data/controllers/product_controller.dart';
import 'package:acctally/app/modules/costs/views/cost_report_screen.dart';
import 'package:acctally/app/modules/sales/views/sales_report_screen.dart';
import 'package:acctally/app/shared/widgets/custom_app_bar.dart';
import 'package:acctally/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailScreen extends StatefulWidget {
  final int? productId;

  const ProductDetailScreen({super.key, this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final ProductController productController = Get.find();
  String productName = '';

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    _loadProductName();
  }

  void _loadProductName() async {
    if (widget.productId != null) {
      final product = await productController.getProductById(widget.productId!);
      if (product != null) {
        setState(() {
          productName = product.name;
        });
      }
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: productName.isNotEmpty ? productName : 'product'.tr),
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
        return Center(child: CostReportScreen(productId: widget.productId));
      case 1:
        return Center(child: SalesReportScreen(productId: widget.productId));
      default:
        return const SizedBox.shrink();
    }
  }
}
