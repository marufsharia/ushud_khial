import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ushud_khial/data/models/medicine_model.dart';
import 'reminder_controller.dart';

class ReminderView extends GetView<ReminderController> {
  const ReminderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.todayReminders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_available,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 20),
                Text(
                  'আজকে কোনো ওষুধ নেই',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 20,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: controller.todayReminders.length,
          itemBuilder: (context, index) {
            final medicine = controller.todayReminders[index];
            return ReminderCard(medicine: medicine);
          },
        );
      }),
    );
  }
}

class ReminderCard extends StatelessWidget {
  final MedicineModel medicine;

  const ReminderCard({super.key, required this.medicine});

  String getTimeOfDay(String time) {
    final hour = int.parse(time.split(':')[0]);
    if (hour < 12) return 'সকাল';
    if (hour < 17) return 'দুপুর';
    return 'রাত';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReminderController>();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              medicine.name,
              style: GoogleFonts.hindSiliguri(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'ডোজ: ${medicine.dosage}',
              style: GoogleFonts.hindSiliguri(color: Colors.grey.shade700),
            ),
            SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: medicine.times.map((time) {
                return GetBuilder<ReminderController>(
                  builder: (controller) {
                    final isTaken = controller.isTaken(medicine.id!, time);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 18,
                                color: Colors.teal,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '$time (${getTimeOfDay(time)})',
                                style: GoogleFonts.hindSiliguri(
                                  fontSize: 16,
                                  decoration: isTaken
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: isTaken ? Colors.grey : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          isTaken
                              ? Chip(
                                  label: Text(
                                    'খাওয়া হয়েছে',
                                    style: GoogleFonts.hindSiliguri(
                                      fontSize: 12,
                                    ),
                                  ),
                                  backgroundColor: Colors.green.shade100,
                                )
                              : OutlinedButton(
                                  onPressed: () => controller.markAsTaken(
                                    medicine.id!,
                                    time,
                                  ),
                                  child: Text(
                                    'খেয়েছি',
                                    style: GoogleFonts.hindSiliguri(),
                                  ),
                                ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
