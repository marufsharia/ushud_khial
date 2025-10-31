import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ushud_khial/core/database/medicine_db.dart';
import 'package:ushud_khial/core/services/notification_service.dart';
import 'package:ushud_khial/data/models/medicine_model.dart';

import '../home/home_controller.dart';
import '../reminder/reminder_controller.dart';

class AddMedicineController extends GetxController {
  final MedicineDB _medicineDB = Get.find<MedicineDB>();
  final NotificationService _notificationService =
      Get.find<NotificationService>();

  // Controllers
  final nameController = TextEditingController();
  final dosageController = TextEditingController();
  final doctorNameController = TextEditingController();
  final doctorContactController = TextEditingController();

  // Reactive variables
  var selectedFrequency = 1.obs;
  var selectedTimes = <TimeOfDay>[].obs;
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().add(const Duration(days: 7)).obs;
  var selectedColor = 0.obs;
  var currentStock = 30.obs;
  var refillThreshold = 10.obs;

  // Color palette
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

  // Time selector
  void addTime(TimeOfDay time) {
    if (!selectedTimes.contains(time)) selectedTimes.add(time);
  }

  void removeTime(int index) {
    selectedTimes.removeAt(index);
  }

  // Date picker
  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? startDate.value : endDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      isStartDate ? startDate.value = picked : endDate.value = picked;
    }
  }

  // Save medicine
  Future<void> saveMedicine(BuildContext context) async {
    if (nameController.text.isEmpty ||
        dosageController.text.isEmpty ||
        selectedTimes.isEmpty) {
      Get.snackbar(
        'ত্রুটি',
        'অনুগ্রহ করে সব তথ্য পূরণ করুন',
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final medicine = MedicineModel(
      name: nameController.text,
      dosage: dosageController.text,
      frequency: selectedFrequency.value,
      times: selectedTimes.map((t) => t.format(context)).toList(),
      startDate: startDate.value,
      endDate: endDate.value,
      doctorName: doctorNameController.text.isEmpty
          ? null
          : doctorNameController.text,
      doctorContact: doctorContactController.text.isEmpty
          ? null
          : doctorContactController.text,
      color: selectedColor.value,
      currentStock: currentStock.value,
      refillThreshold: refillThreshold.value,
    );

    final createdMedicine = await _medicineDB.create(medicine);

    // Refill notification
    if (createdMedicine.currentStock <= createdMedicine.refillThreshold) {
      _notificationService.showInstantNotification(
        (createdMedicine.id! * 1000),
        'রিফিল রিমাইন্ডার',
        '${createdMedicine.name} ওষুধ কিনতে ভুলবেন না। বর্তমান স্টক: ${createdMedicine.currentStock}',
      );
    }

    // Schedule medicine notifications
    for (int i = 0; i < createdMedicine.times.length; i++) {
      final timeOfDay = _parseTimeString(createdMedicine.times[i]);
      DateTime scheduledDate = DateTime(
        createdMedicine.startDate.year,
        createdMedicine.startDate.month,
        createdMedicine.startDate.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );

      if (scheduledDate.isBefore(DateTime.now()))
        scheduledDate = scheduledDate.add(Duration(days: 1));

      int notificationId = (createdMedicine.id! * 100) + i;

      debugPrint(
        "Scheduling notification for: $scheduledDate (ID: $notificationId)",
      );

      await _notificationService.scheduleNotification(
        notificationId,
        'ওষুধ খাওয়ার সময়',
        '${createdMedicine.name} (${createdMedicine.dosage}) খেতে ভুলবেন না।',
        scheduledDate,
      );
    }

    // Update UI
    Get.find<HomeController>().fetchMedicines();
    Get.find<ReminderController>().fetchTodayReminders();

    Get.snackbar(
      'সফল',
      'ওষুধ সফলভাবে যোগ করা হয়েছে',
      backgroundColor: Colors.green,
    );
    Get.back();
  }

  // Convert "08:00 AM" to TimeOfDay
  TimeOfDay _parseTimeString(String timeString) {
    final parts = timeString.split(' ');
    final hourMinute = parts[0].split(':');
    int hour = int.parse(hourMinute[0]);
    final minute = int.parse(hourMinute[1]);

    if (parts[1] == 'PM' && hour != 12) hour += 12;
    if (parts[1] == 'AM' && hour == 12) hour = 0;

    return TimeOfDay(hour: hour, minute: minute);
  }
}
