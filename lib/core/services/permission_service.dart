import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  /// নোটিফিকেশন পারমিশন চেক করে এবং প্রয়োজনীয় ক্ষেত্রে অনুরোধ করে
  Future<void> checkNotificationPermission() async {
    final status = await Permission.notification.status;

    if (status.isGranted) {
      Get.snackbar(
        'পারমিশন',
        'নোটিফিকেশন অনুমতি দেওয়া আছে।',
        backgroundColor: Colors.green,
      );
      return;
    }

    if (status.isDenied) {
      // যদি পারমিশন দেওয়া হয়নি, তাহলে অনুরোধ করুন
      await Permission.notification.request();
      Get.snackbar('পারমিশন', 'অনুগ্রহ করে নোটিফিকেশন অনুমতি দিন।');
      return;
    }

    // যদি স্থায়ীভাবে বাতিল করা হয়েছে, তাহলে সেটিংসে নিয়ে যাওয়ার জন্য ডায়ালগ দেখান
    _showDialogAndOpenSettings(
      title: 'নোটিফিকেশন প্রয়োজনীয়',
      message:
          'অ্যাপটিকে নোটিফিকেশন পাঠানোর জন্য অনুমতি প্রয়োজন। সেটিংস থেকে ম্যানুয়ালি অনুমতি দিন।',
    );
  }

  /// ব্যাটারি অপ্টিমাইজেশন চেক করে এবং প্রয়োজনীয় ক্ষেত্রে সেটিংসে নিয়ে নেয়ার জন্য ডায়ালগ দেখায়
  Future<void> checkBatteryOptimization() async {
    // এই পারমিশনটি অ্যান্ড্রয়েডের জন্য অত্যন্ত গুরুত্বপূর্ণ
    final status = await Permission.ignoreBatteryOptimizations.status;

    if (status.isGranted) {
      Get.snackbar(
        'ব্যাটারি',
        'ব্যাটারি অপ্টিমাইজেশন বন্ধ আছে।',
        backgroundColor: Colors.green,
      );
      return;
    }

    if (status.isDenied) {
      // যদি অপ্টিমাইজেশন আছে, তাহলে অনুরোধ করুন
      await Permission.ignoreBatteryOptimizations.request();
      Get.snackbar('ব্যাটারি', 'অনুগ্রহ করে ব্যাটারি অপ্টিমাইজেশন বন্ধ করুন।');
      return;
    }

    // যদি স্থায়ীভাবে বাতিল করা হয়েছে, তাহলে সেটিংসে নিয়ে যাওয়ার জন্য ডায়ালগ দেখান
    _showDialogAndOpenSettings(
      title: 'ব্যাটারি অপ্টিমাইজেশন',
      message:
          'অ্যাপটিকে ব্যাকগ্রাউন্ডে সঠিকভাবে কাজ করার জন্য ব্যাটারি অপ্টিমাইজেশন বন্ধ করুন। সেটিংস থেকে ম্যানুয়ালি অনুমতি দিন।',
    );
  }

  /// একটি ডায়ালগ দেখানো এবং সেটিংস অ্যাপ খোলার জন্য হেলপার মেথড
  void _showDialogAndOpenSettings({
    required String title,
    required String message,
  }) {
    Get.defaultDialog(
      title: title,
      titleStyle: Get.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      middleText: message,
      middleTextStyle: Get.textTheme.bodyMedium,
      textConfirm: 'সেটিংসে যান',
      textCancel: '�াতিল',
      confirmTextColor: Colors.white,
      buttonColor: Get.theme.primaryColor,
      onConfirm: () {
        Get.back(); // ডায়ালগ বন্ধ করুন
        openAppSettings(); // সেটিংস অ্যাপ খুলুন
      },
      barrierDismissible: false, // বাইরে ট্যাপ করে বন্ধ করা যাবে না
    );
  }
}
