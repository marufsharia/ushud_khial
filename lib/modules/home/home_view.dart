import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:ushud_khial/core/config/app_routes.dart';
import 'package:ushud_khial/data/models/medicine_model.dart';

import '../medicine_details/medicine_details_controller.dart';
import '../medicine_details/medicine_details_view.dart';
import 'home_controller.dart';

/// Helper class to avoid repetition
class MedicineHelper {
  static const List<Color> medicineColors = [
    Colors.teal,
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.green,
    Colors.pink,
    Colors.indigo,
  ];

  static Color getMedicineColor(int colorIndex) =>
      medicineColors[colorIndex.clamp(0, medicineColors.length - 1)];

  static String getStockStatusText(int currentStock, int refillThreshold) {
    if (currentStock == 0) return 'স্টক শেষ';
    if (currentStock <= refillThreshold) return 'শীঘ্রই কিনুন';
    return 'পর্যাপ্ত স্টক';
  }

  static Color getStockStatusColor(int currentStock, int refillThreshold) {
    if (currentStock == 0) return Colors.red;
    if (currentStock <= refillThreshold) return Colors.orange;
    return Colors.green;
  }

  static IconData getStockStatusIcon(int currentStock, int refillThreshold) {
    if (currentStock == 0) return Icons.error_outline;
    if (currentStock <= refillThreshold) return Icons.warning_amber;
    return Icons.check_circle_outline;
  }
}

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.medicines.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          itemCount: controller.medicines.length,
          itemBuilder: (context, index) {
            final medicine = controller.medicines[index];
            return ModernMedicineCard(medicine: medicine)
                .animate(delay: (100 * index).ms)
                .slideX(begin: 0.2, end: 0)
                .fadeIn();
          },
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/doctor.json', width: 250, height: 250),
          const SizedBox(height: 20),
          Text(
            'আপনার ওষুধের তালিকা খালি',
            style: GoogleFonts.hindSiliguri(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 8),
          Text(
            'নিচের বাটনে ক্লিক করে আপনার প্রথম ওষুধ যোগ করুন',
            textAlign: TextAlign.center,
            style: GoogleFonts.hindSiliguri(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ).animate().fadeIn(delay: 600.ms),
          const SizedBox(height: 30),
          FilledButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.addMedicine),
            icon: const Icon(Icons.add),
            label: const Text('প্রথম ওষুধ যোগ করুন'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
            ),
          ).animate().fadeIn(delay: 800.ms).scale(),
        ],
      ),
    );
  }
}

/// Modern medicine card with reactive styling
class ModernMedicineCard extends StatelessWidget {
  final MedicineModel medicine;

  const ModernMedicineCard({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    final cardColor = MedicineHelper.getMedicineColor(medicine.color);
    final stockColor = MedicineHelper.getStockStatusColor(
      medicine.currentStock,
      medicine.refillThreshold,
    );
    final stockIcon = MedicineHelper.getStockStatusIcon(
      medicine.currentStock,
      medicine.refillThreshold,
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          debugPrint('Medicine tapped: ${medicine.toString()}');
          Get.toNamed('${AppRoutes.detailsMedicine}/?id=${medicine.id}');
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [cardColor.withOpacity(0.1), cardColor.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Hero(
                tag: 'medicine-icon-${medicine.id}',
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: cardColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.medication,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(stockIcon, color: stockColor, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            medicine.name,
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ডোজ: ${medicine.dosage}',
                      style: GoogleFonts.hindSiliguri(color: Colors.black54),
                    ),
                    if (medicine.doctorName != null)
                      Text(
                        'ডাক্তার: ${medicine.doctorName}',
                        style: GoogleFonts.hindSiliguri(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${medicine.currentStock} টি',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: stockColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(Icons.arrow_forward_ios, color: cardColor, size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
