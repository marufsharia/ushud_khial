import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ushud_khial/core/database/medicine_db.dart';
import 'package:ushud_khial/core/services/notification_service.dart';
import 'package:ushud_khial/data/models/medicine_model.dart';
import 'package:ushud_khial/modules/reminder/reminder_controller.dart';

import '../home/home_controller.dart';

class AddMedicineController extends GetxController {
  final MedicineDB _medicineDB = Get.find<MedicineDB>();
  final NotificationService _notificationService =
      Get.find<NotificationService>();

  final nameController = TextEditingController();
  final dosageController = TextEditingController();

  var selectedFrequency = 1.obs;
  var selectedTimes = <TimeOfDay>[].obs;
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().add(const Duration(days: 7)).obs;
  final doctorNameController = TextEditingController(); // নতুন
  final doctorContactController = TextEditingController(); // নতুন
  var selectedColor = 0.obs; // নতুন, ডিফল্ট Teal

  // রঙের তালিকা (Material Colors থেকে)
  final List<Color> medicineColors = [
    Colors.teal,
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.green,
    Colors.pink,
    Colors.indigo,
  ];

  void addTime(TimeOfDay time) {
    if (!selectedTimes.contains(time)) {
      selectedTimes.add(time);
    }
  }

  void removeTime(int index) {
    selectedTimes.removeAt(index);
    update();
  }

  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? startDate.value : endDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      if (isStartDate) {
        startDate.value = picked;
      } else {
        endDate.value = picked;
      }
    }
  }

  Future<void> saveMedicine(BuildContext context) async {
    if (nameController.text.isEmpty ||
        dosageController.text.isEmpty ||
        selectedTimes.isEmpty) {
      Get.snackbar(
        'ত্রুটি',
        'অনুগ্রহ করে সব তথ্য সঠিকভাবে পূরণ করুন',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final medicine = MedicineModel(
      name: nameController.text,
      dosage: dosageController.text,
      frequency: selectedFrequency.value,
      times: selectedTimes.map((time) => time.format(context)).toList(),
      startDate: startDate.value,
      endDate: endDate.value,
      doctorName: doctorNameController.text.isEmpty
          ? null
          : doctorNameController.text,
      doctorContact: doctorContactController.text.isEmpty
          ? null
          : doctorContactController.text,
      color: selectedColor.value, // নির্বাচিত রঙ যোগ করুন
    );

    final createdMedicine = await _medicineDB.create(medicine);

    // নোটিফিকেশন শিডিউল করা
    for (int i = 0; i < createdMedicine.times.length; i++) {
      final timeParts = createdMedicine.times[i].split(' ');
      final hourMin = timeParts[0].split(':');
      final hour = int.parse(hourMin[0]);
      final minute = int.parse(hourMin[1]);
      final period = timeParts[1]; // AM or PM

      int notificationHour = hour;
      if (period == 'PM' && hour != 12) {
        notificationHour += 12;
      } else if (period == 'AM' && hour == 12) {
        notificationHour = 0;
      }

      final scheduledDateTime = DateTime(
        createdMedicine.startDate.year,
        createdMedicine.startDate.month,
        createdMedicine.startDate.day,
        notificationHour,
        minute,
      );

      // একটি ইউনিক ID তৈরি করা
      int notificationId = (createdMedicine.id! * 100) + i;

      await _notificationService.scheduleNotification(
        notificationId,
        'ওষুধ খাওয়ার সময়',
        '${createdMedicine.name} (${createdMedicine.dosage}) খেতে ভুলবেন না।',
        scheduledDateTime,
      );
    }
    Get.find<HomeController>().fetchMedicines();
    Get.find<ReminderController>().fetchTodayReminders();
    Get.back(); // হোম পেজে ফিরে যাওয়া
    Get.snackbar('সফল', 'ওষুধটি সফলভাবে যোগ করা হয়েছে');
  }
}
