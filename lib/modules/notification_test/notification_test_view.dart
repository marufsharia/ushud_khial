import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'notification_test_controller.dart';

class NotificationTestView extends GetView<NotificationTestController> {
  const NotificationTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('নোটিফিকেশন টেস্ট')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: controller.showSimpleNotification,
                child: const Text('সাধারণ নোটিফিকেশন দেখান'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: controller.showScheduledNotification,
                child: const Text('৫ সেকেন্ড পরে নোটিফিকেশন দেখান'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: controller.showShortScheduledNotification,
                child: const Text('১০ সেকেন্ড পরে নোটিফিকেশন দেখান'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
