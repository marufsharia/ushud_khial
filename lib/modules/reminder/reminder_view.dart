import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ushud_khial/data/models/medicine_model.dart';

import 'reminder_controller.dart';

class ReminderView extends GetView<ReminderController> {
  const ReminderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.todayReminders.isEmpty) {
          return _buildEmptyState();
        }
        return Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                itemCount: controller.todayReminders.length,
                itemBuilder: (context, index) {
                  final medicine = controller.todayReminders[index];
                  return ReminderCard(medicine: medicine);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  // হেডার সেকশন যোগ করা হয়েছে
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Text(
        'আজকের ওষুধ',
        textAlign: TextAlign.center,
        style: Get.theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Get.theme.primaryColor,
        ),
      ),
    );
  }

  // উন্নত খালি স্টেট
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/doctor.json', // একই অ্যানিমেশন ব্যবহার করা হয়েছে
            width: 250,
            height: 250,
          ),
          const SizedBox(height: 20),
          Text(
            'আজকে কোনো ওষুধ নেই',
            style: Get.theme.textTheme.titleLarge?.copyWith(
              color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'আপনার আজকের সব রিমাইন্ডার এখানে দেখানো হবে',
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
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
    final cardColor = Get.theme.colorScheme.primaryContainer;

    return Card(
      // থিম থেকে কার্ডের ডিজাইন নেওয়া হচ্ছে
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.medication,
                    color: Get.theme.colorScheme.onPrimaryContainer,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicine.name,
                        style: Get.theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ডোজ: ${medicine.dosage}',
                        style: Get.theme.textTheme.bodyMedium?.copyWith(
                          color: Get.theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            const SizedBox(height: 16),
            ...medicine.times.map((time) {
              // isTaken চেক করার জন্য Obx ব্যবহার করা হচ্ছে
              // এটি শুধুমাত্র এই নির্দিষ্ট রো রিবিল্ড করবে
              final isTaken = controller.isTaken(medicine.id!, time);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // এখানে আমাদের নতুন উইজেট ব্যবহার করুন
                    _buildTimeChip(time, isTaken),

                    // বাটন/চিপ অংশটি অপরিবর্তিত নেই
                    isTaken
                        ? Chip(
                            label: Text(
                              'খাওয়া হয়েছে',
                              style: Get.theme.textTheme.bodySmall?.copyWith(
                                color: Get.theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: Get.theme.colorScheme.primary,
                          )
                        : FilledButton.tonal(
                            onPressed: () =>
                                controller.markAsTaken(medicine.id!, time),
                            child: Text('খেয়েছি'),
                          ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // ReminderCard ক্লাসের ভিতরে এই মেথডটি যোগ করুন
  Widget _buildTimeChip(String time, bool isTaken) {
    final timeOfDay = getTimeOfDay(time);

    // থিম অনুযায়ী রঙ নির্ধারণ করা হচ্ছে
    final primaryColor = isTaken
        ? Get.theme.colorScheme.onSurface.withOpacity(0.5)
        : Get.theme.colorScheme.primary;

    final secondaryColor = isTaken
        ? Get.theme.colorScheme.onSurface.withOpacity(0.4)
        : Get.theme.colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time_filled, size: 16, color: primaryColor),
          const SizedBox(width: 6),
          Text(
            time,
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: primaryColor,
              decoration: isTaken ? TextDecoration.lineThrough : null,
            ),
          ),
          Text(
            ' ($timeOfDay)',
            style: Get.theme.textTheme.bodySmall?.copyWith(
              color: secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
