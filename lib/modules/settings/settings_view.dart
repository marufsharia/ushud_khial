import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ushud_khial/core/config/constants.dart';
import 'settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          Obx(
            () => SwitchListTile(
              title: Text('নোটিফিকেশন', style: GoogleFonts.hindSiliguri()),
              subtitle: Text(
                'ওষুধের রিমাইন্ডার পান',
                style: GoogleFonts.hindSiliguri(),
              ),
              secondary: const Icon(Icons.notifications_active),
              value: controller.isNotificationEnabled.value,
              onChanged: controller.toggleNotification,
            ),
          ),
          Obx(
            () => SwitchListTile(
              title: Text('ডার্ক মোড', style: GoogleFonts.hindSiliguri()),
              subtitle: Text(
                'অ্যাপের থিম পরিবর্তন করুন',
                style: GoogleFonts.hindSiliguri(),
              ),
              secondary: const Icon(Icons.dark_mode),
              value: controller.isDarkMode.value,
              onChanged: controller.toggleTheme,
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(
              'সব ডেটা মুছে ফেলুন',
              style: GoogleFonts.hindSiliguri(color: Colors.red),
            ),
            subtitle: Text(
              'ওষুধ ও রেকর্ড সব মুছে যাবে',
              style: GoogleFonts.hindSiliguri(),
            ),
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            onTap: controller.clearAllData,
          ),
          const Divider(),
          ListTile(
            title: Text('অ্যাপ সম্পর্কে', style: GoogleFonts.hindSiliguri()),
            subtitle: Text(
              'ভার্সন: ${AppConstants.appVersion}',
              style: GoogleFonts.hindSiliguri(),
            ),
            leading: const Icon(Icons.info_outline),
          ),
        ],
      ),
    );
  }
}
