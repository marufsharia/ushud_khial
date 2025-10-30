import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ushud_khial/core/config/app_theme.dart';
import 'package:ushud_khial/core/database/medicine_db.dart';

import '../../core/config/constants.dart';

class SettingsController extends GetxController {
  final MedicineDB _medicineDB = Get.find<MedicineDB>();
  final box = GetStorage();

  var isNotificationEnabled = true.obs;
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  void loadSettings() {
    isNotificationEnabled.value = box.read('notification_enabled') ?? true;
    isDarkMode.value = box.read('is_dark_mode') ?? false;
    // থিম লোড করা
    Get.changeTheme(
      isDarkMode.value ? AppTheme.darkTheme : AppTheme.lightTheme,
    );
  }

  void toggleNotification(bool value) {
    isNotificationEnabled.value = value;
    box.write('notification_enabled', value);
    Get.snackbar(
      'সেটিংস',
      value ? 'নোটিফিকেশন চালু করা হয়েছে' : 'নোটিফিকেশন বন্ধ করা হয়েছে',
    );
  }

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    box.write('is_dark_mode', value);
    Get.changeTheme(value ? AppTheme.darkTheme : AppTheme.lightTheme);
    Get.snackbar(
      'সেটিংস',
      value ? 'ডার্ক মোড চালু করা হয়েছে' : 'লাইট মোড চালু করা হয়েছে',
    );
  }

  void clearAllData() {
    Get.defaultDialog(
      title: 'সব ডেটা মুছে ফেলুন',
      titleStyle: Get.textTheme.headlineSmall,
      middleText:
          'আপনি কি নিশ্চিত? এতে আপনার সব ওষুধের তালিকা এবং রেকর্ড স্থায়ীভাবে মুছে যাবে।',
      middleTextStyle: Get.textTheme.bodyMedium,
      textConfirm: 'হ্যাঁ',
      textCancel: 'না',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        await _medicineDB.close(); // ডাটাবেস ক্লোজ করা
        await _medicineDB.database.then(
          (db) => db.delete(AppConstants.dbTable),
        ); // টেবিল মুছে ফেলা
        box.erase(); // GetStorage মুছে ফেলা
        Get.snackbar(
          'সফল',
          'সব ডেটা মুছে ফেলা হয়েছে। অ্যাপ রিস্টার্ট হচ্ছে...',
        );
        // অ্যাপ রিস্টার্ট করার জন্য
        Future.delayed(Duration(seconds: 2), () {
          Get.reset(); // সব কন্ট্রোলার রিসেট করা
          Get.offAllNamed('/main'); // মূল পেজে ফিরে যাওয়া
        });
      },
    );
  }
}
