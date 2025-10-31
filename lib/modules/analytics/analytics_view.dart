import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'analytics_controller.dart';

class AnalyticsView extends GetView<AnalyticsController> {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(() {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAdherenceCard(),
              const SizedBox(height: 20),
              _buildStockWarningCard(),
              const SizedBox(height: 20),
              _buildPieChart(),
            ],
          ),
        );
      }),
    );
  }

  // নিয়মিততার কার্ড
  Widget _buildAdherenceCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'গত ৭ দিনের নিয়মিততা',
            style: Get.theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Get.theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          // বড় পার্সেন্টেজ টেক্সট
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              color: Get.theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${controller.adherencePercentage.value.toStringAsFixed(1)}%',
              style: Get.theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Get.theme.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // পরিসংখ্যানের আইটেমগুলো
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'খাওয়া হয়েছে',
                controller.totalMedicinesTaken.value,
                Get.theme.colorScheme.primary,
              ),
              _buildStatItem(
                'মিস করা হয়েছে',
                controller.totalMedicinesMissed.value,
                Get.theme.colorScheme.error,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // পরিসংখ্যানের আইটেম উইজেট
  Widget _buildStatItem(String title, int value, Color color) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            value.toString(),
            style: Get.theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              color: Get.theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  // স্টক সতর্কতা কার্ড (ডার্ক/লাইট মোড অনুযায়ী)
  Widget _buildStockWarningCard() {
    // থিম অনুযায়ী রঙ নির্বাচন
    final isDark = Get.theme.brightness == Brightness.dark;
    final cardBgColor = isDark
        ? Colors.orange.shade900.withOpacity(0.3)
        : Colors.orange.shade50;
    final iconColor = isDark ? Colors.orange.shade300 : Colors.orange.shade800;
    final titleColor = isDark ? Colors.orange.shade200 : Colors.orange.shade900;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber, color: iconColor, size: 28),
              const SizedBox(width: 12),
              Text(
                'রিফিলের জন্য ওষুধ',
                style: Get.theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (controller.lowStockMedicines.isEmpty)
            Text(
              'সব ওষুধের পর্যাপ্ত স্টক আছে।',
              style: Get.theme.textTheme.bodyMedium?.copyWith(
                color: Get.theme.colorScheme.onSurface,
              ),
            )
          else
            ...controller.lowStockMedicines
                .map(
                  (med) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Icon(Icons.circle, color: iconColor, size: 8),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${med.name} (বাকি: ${med.currentStock})',
                            style: Get.theme.textTheme.bodyMedium?.copyWith(
                              color: Get.theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
        ],
      ),
    );
  }

  // পাই চার্ট কার্ড
  Widget _buildPieChart() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'ডোজের বিবরণ',
            style: Get.theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Get.theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                centerSpaceColor: Get.theme.cardColor,
                sections: [
                  PieChartSectionData(
                    color: Get.theme.colorScheme.primary,
                    value: controller.totalMedicinesTaken.value.toDouble(),
                    title: '${controller.totalMedicinesTaken.value}',
                    radius: 60,
                    titleStyle: Get.theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.onPrimary,
                    ),
                    badgeWidget: _Badge(
                      'খাওয়া হয়েছে',
                      Get.theme.colorScheme.primary,
                      Get.theme.colorScheme.onPrimary,
                    ),
                    badgePositionPercentageOffset: .98,
                  ),
                  PieChartSectionData(
                    color: Get.theme.colorScheme.error,
                    value: controller.totalMedicinesMissed.value.toDouble(),
                    title: '${controller.totalMedicinesMissed.value}',
                    radius: 60,
                    titleStyle: Get.theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.onError,
                    ),
                    badgeWidget: _Badge(
                      'মিস করা হয়েছে',
                      Get.theme.colorScheme.error,
                      Get.theme.colorScheme.onError,
                    ),
                    badgePositionPercentageOffset: .98,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// চার্টের লেবেলের জন্য একটি কাস্টম ব্যাজ উইজেট
class _Badge extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;

  const _Badge(this.text, this.bgColor, this.textColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
