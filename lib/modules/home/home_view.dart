import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ushud_khial/data/models/medicine_model.dart';

import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // AppBar এবং Scaffold সরিয়ে ফেলা হয়েছে
    return SafeArea(
      child: Column(
        children: [
          // একটি কাস্টম AppBar যোগ করা হলো
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.teal,
            child: Row(
              children: [
                Icon(Icons.medication, color: Colors.white, size: 28),
                SizedBox(width: 10),
                Text(
                  'ওষুধের খেয়াল',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // বাকি অংশ একই থাকবে, শুধু body অংশটি Expanded এর ভিতরে নিতে হবে
          Expanded(
            child: Obx(() {
              final medicinesList = controller.medicines;
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (medicinesList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.medication_outlined,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'কোনো ওষুধ যোগ করা হয়নি',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 20,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'নিচের বোতামে চাপ দিয়ে ওষুধ যোগ করুন',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 16,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemCount: medicinesList.length,
                itemBuilder: (context, index) {
                  final medicine = medicinesList[index];
                  return MedicineCard(medicine: medicine);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class MedicineCard extends StatelessWidget {
  final MedicineModel medicine;

  const MedicineCard({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(Icons.medication, color: Colors.teal, size: 40),
        title: Text(
          medicine.name,
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'ডোজ: ${medicine.dosage}\nসময়: ${medicine.times.join(', ')}',
          style: GoogleFonts.hindSiliguri(),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () {
            Get.defaultDialog(
              title: 'ওষুধ মুছে ফেলুন',
              titleStyle: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
              middleText: 'আপনি কি ${medicine.name} মুছে ফেলতে চান?',
              middleTextStyle: GoogleFonts.hindSiliguri(),
              textConfirm: 'হ্যাঁ',
              textCancel: 'না',
              confirmTextColor: Colors.white,
              buttonColor: Colors.red,
              onConfirm: () {
                Get.find<HomeController>().deleteMedicine(medicine.id!);
                Get.back();
              },
            );
          },
        ),
        isThreeLine: true,
      ),
    );
  }
}
