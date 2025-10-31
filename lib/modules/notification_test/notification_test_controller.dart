import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../core/services/notification_service.dart';

class NotificationTestController extends GetxController {
  final NotificationService _notificationService = NotificationService();

  @override
  void onInit() {
    super.onInit();
    _notificationService.initialize();
  }

  Future<void> showSimpleNotification() async {
    debugPrint("Button pressed! Showing simple notification...");
    await _notificationService.showInstantNotification(
      123,
      'সাধারণ নোটিফিকেশন',
      'এটি একটি সাধারণ টেস্ট নোটিফিকেশন।',
    );
  }

  Future<void> showScheduledNotification() async {
    debugPrint(
      "Button pressed! Trying to schedule notification after 5 seconds...",
    );
    final scheduledTime = DateTime.now().add(const Duration(seconds: 5));

    await _notificationService.scheduleNotification(
      456,
      'শিডিউল করা নোটিফিকেশন',
      'এটি ৫ সেকেন্ড পরে আসা উচিত।',
      scheduledTime,
    );
  }

  Future<void> showShortScheduledNotification() async {
    debugPrint(
      "Button pressed! Trying to schedule notification for 10 seconds later...",
    );
    final scheduledTime = DateTime.now().add(const Duration(seconds: 10));

    await _notificationService.scheduleNotification(
      789,
      'স্বল্প সময়ের টেস্ট',
      'এটি ১০ সেকেন্ড পরে আসা উচিত।',
      scheduledTime,
    );
  }
}
