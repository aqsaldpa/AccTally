import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class CostReportScreen extends StatefulWidget {
  const CostReportScreen({super.key});

  @override
  State<CostReportScreen> createState() => _CostReportScreenState();
}

class _CostReportScreenState extends State<CostReportScreen> {
  final Map<String, dynamic> costData = {
    'rawMaterials': {
      'total': 8000,
      'items': [
        {'name': 'Rice', 'amount': 0},
        {'name': 'Chicken', 'amount': 0},
      ],
      'color': const Color(0xFF10B981),
    },
    'directLabor': {
      'total': 2000,
      'items': [
        {'name': 'Worker Salary', 'amount': 0},
      ],
      'color': const Color(0xFFEAB308),
    },
    'overhead': {
      'total': 2000,
      'items': [
        {'name': 'Stall Rent', 'amount': 0},
      ],
      'color': const Color(0xFFA3E635),
    },
  };

  int get totalCost {
    return costData.values.fold(
      0,
      (sum, category) => sum + (category['total'] as int),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 80,
                        sections: buildPieChartSections(),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${'currency'.tr} ${totalCost.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildLegendItem(
                    'rawMaterials'.tr,
                    costData['rawMaterials']['color'],
                  ),
                  const SizedBox(width: 16),
                  buildLegendItem(
                    'directLabor'.tr,
                    costData['directLabor']['color'],
                  ),
                  const SizedBox(width: 16),
                  buildLegendItem('overhead'.tr, costData['overhead']['color']),
                ],
              ),

              const SizedBox(height: 24),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'costProductSummary'.tr,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildCostSection(
                        'rawMaterials'.tr,
                        '${'currency'.tr} ${costData['rawMaterials']['total']}',
                        costData['rawMaterials']['items'],
                      ),

                      const SizedBox(height: 16),

                      buildCostSection(
                        'directLabor'.tr,
                        '${'currency'.tr} ${costData['directLabor']['total']}',
                        costData['directLabor']['items'],
                      ),

                      const SizedBox(height: 16),

                      buildCostSection(
                        'overhead'.tr,
                        '${'currency'.tr} ${costData['overhead']['total']}',
                        costData['overhead']['items'],
                      ),

                      const SizedBox(height: 16),

                      const Divider(height: 16),

                      const SizedBox(height: 6),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'totalAllCosts'.tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${'currency'.tr} ${totalCost.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> buildPieChartSections() {
    return [
      PieChartSectionData(
        color: costData['rawMaterials']['color'],
        value: costData['rawMaterials']['total'].toDouble(),
        title: '${'currency'.tr} ${costData['rawMaterials']['total']}',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: costData['directLabor']['color'],
        value: costData['directLabor']['total'].toDouble(),
        title: '${'currency'.tr} ${costData['directLabor']['total']}',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: costData['overhead']['color'],
        value: costData['overhead']['total'].toDouble(),
        title: '${'currency'.tr} ${costData['overhead']['total']}',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  Widget buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget buildCostSection(
    String title,
    String amount,
    List<Map<String, dynamic>> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Color(0xFF64748B),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
