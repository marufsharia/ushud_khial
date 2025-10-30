import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:ushud_khial/data/models/medicine_model.dart';

import '../medicine_details/lib/modules/medicine_details/medicine_details_view.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // AppBar এবং Container সরিয়ে ফেলা হয়েছে
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.medicines.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/doctor.json',
                  width: 200,
                  height: 200,
                ),

                SizedBox(height: 20),
                Text(
                      'কোনো ওষুধ যোগ করা হয়নি',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 20,
                        color: Colors.grey.shade600,
                      ),
                    )
                    .animate()
                    .scale(duration: 500.ms)
                    .fadeIn(duration: 1000.ms)
                    .slideY(begin: 0.3, end: 0),
              ],
            ),
          );
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
}

class ModernMedicineCard extends StatelessWidget {
  final MedicineModel medicine;

  const ModernMedicineCard({super.key, required this.medicine});

  Color getMedicineColor() {
    final colors = [
      Colors.teal,
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.purple,
      Colors.green,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[medicine.color.clamp(0, colors.length - 1)];
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = getMedicineColor();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => Get.to(() => MedicineDetailsView(medicine: medicine)),
        child: AnimatedContainer(
          duration: 300.ms,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [cardColor.withOpacity(0.1), cardColor.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: cardColor.withOpacity(0.15),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
                  cardColor.withOpacity(0.1),
                  cardColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.medication, color: Colors.white, size: 28),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicine.name,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
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
                Icon(Icons.arrow_forward_ios, color: cardColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
