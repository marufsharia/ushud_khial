import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ushud_khial/core/config/app_routes.dart';
import 'package:ushud_khial/modules/main/main_controller.dart';
import 'package:ushud_khial/modules/settings/settings_controller.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<MainController>();
    final settingsController = Get.find<SettingsController>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildDrawerItem(
            icon: Icons.list_alt,
            title: 'ওষুধের তালিকা',
            onTap: () {
              mainController.changePage(0);
              Get.back(); // Drawer বন্ধ করার জন্য
            },
            isSelected: mainController.currentIndex.value == 0,
          ),
          _buildDrawerItem(
            icon: Icons.alarm,
            title: 'আজকের রিমাইন্ডার',
            onTap: () {
              mainController.changePage(1);
              Get.back();
            },
            isSelected: mainController.currentIndex.value == 1,
          ),
          _buildDrawerItem(
            icon: Icons.folder_shared,
            title: 'স্বাস্থ্য রেকর্ড',
            onTap: () {
              mainController.changePage(2);
              Get.back();
            },
            isSelected: mainController.currentIndex.value == 2,
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'সেটিংস',
            onTap: () {
              mainController.changePage(3);
              Get.back();
            },
            isSelected: mainController.currentIndex.value == 3,
          ),
          const Divider(),
          Obx(() {
            final isDarkMode = settingsController.isDarkMode.value;
            return SwitchListTile(
              secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
              title: Text('ডার্ক মোড', style: GoogleFonts.hindSiliguri()),
              value: isDarkMode,
              onChanged: settingsController.toggleTheme,
            );
          }),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text('অ্যাপ সম্পর্কে', style: GoogleFonts.hindSiliguri()),
            onTap: () {
              Get.back();
              showAboutDialog(
                context: context,
                applicationName: 'ওষুধের খেয়াল',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.medication, size: 50),
                children: [
                  Text(
                    'আপনার ওষুধ খাওয়ার রুটিন ম্যানেজ করার জন্য একটি সহজ অ্যাপ।',
                    style: GoogleFonts.hindSiliguri(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Get.theme.primaryColorDark, Get.theme.primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: Get.theme.primaryColor),
          ),
          SizedBox(height: 10),
          Text(
            'স্বাগতম!',
            style: GoogleFonts.hindSiliguri(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'আপনার স্বাস্থ্যের যত্ন নিন',
            style: GoogleFonts.hindSiliguri(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Get.theme.primaryColor : Colors.grey.shade600,
      ),
      title: Text(
        title,
        style: GoogleFonts.hindSiliguri(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Get.theme.primaryColor : Colors.black87,
        ),
      ),
      onTap: onTap,
      tileColor: isSelected ? Get.theme.primaryColor.withOpacity(0.1) : null,
    );
  }
}
