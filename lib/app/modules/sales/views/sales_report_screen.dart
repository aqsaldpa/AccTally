import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({super.key});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  // Dummy data
  final List<Map<String, dynamic>> salesItems = [
    {'product': 'Product A', 'unit': 5, 'total': 250000},
    {'product': 'Product B', 'unit': 3, 'total': 150000},
  ];

  int get totalSales =>
      salesItems.fold(0, (sum, item) => sum + item['total'] as int);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'salesSummaryTitle'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Header row
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            'product'.tr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'unit'.tr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'totalSalesReport'.tr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Sales items
                    ...salesItems.asMap().entries.map((entry) {
                      final item = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Expanded(flex: 4, child: Text(item['product'])),
                            Expanded(
                              flex: 2,
                              child: Text(item['unit'].toString()),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                '${'currency'.tr} ${item['total'].toString()}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    const Divider(height: 16),
                    // Total row
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              'total'.tr,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Expanded(flex: 2, child: Text('')),
                          Expanded(
                            flex: 3,
                            child: Text(
                              '${'currency'.tr} $totalSales',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
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
