import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ushud_khial/modules/main/main_controller.dart';
import 'package:ushud_khial/modules/settings/settings_controller.dart';

import '../../modules/notification_test/notification_test_view.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<MainController>();
    final settingsController = Get.find<SettingsController>();

    return Obx(() {
      return Drawer(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  _buildDrawerItem(
                    icon: Icons.list_alt,
                    title: 'ওষুধের তালিকা',
                    onTap: () => _navigateTo(mainController, 0),
                    isSelected: mainController.currentIndex.value == 0,
                  ),
                  _buildDrawerItem(
                    icon: Icons.alarm,
                    title: 'আজকের রিমাইন্ডার',
                    onTap: () => _navigateTo(mainController, 1),
                    isSelected: mainController.currentIndex.value == 1,
                  ),
                  _buildDrawerItem(
                    icon: Icons.analytics_outlined, // আইকন পরিবর্তন করা হয়েছে
                    title: 'অ্যানালিটিক্স', // শিরোনাম পরিবর্তন করা হয়েছে
                    onTap: () => _navigateTo(mainController, 2),
                    isSelected: mainController.currentIndex.value == 2,
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings,
                    title: 'সেটিংস',
                    onTap: () => _navigateTo(mainController, 3),
                    isSelected: mainController.currentIndex.value == 3,
                  ),
                  _buildDrawerItem(
                    icon: Icons.notifications,
                    title: 'Test Notification',
                    onTap: () {
                      Get.to(NotificationTestView());
                    },
                    isSelected: mainController.currentIndex.value == 3,
                  ),
                ],
              ),
            ),
            const Divider(),
            Obx(
              () => SwitchListTile(
                secondary: Icon(
                  settingsController.isDarkMode.value
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: Get.theme.colorScheme.primary,
                ),
                title: Text('ডার্ক মোড'),
                value: settingsController.isDarkMode.value,
                onChanged: (value) => settingsController.toggleTheme(value),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: Get.theme.colorScheme.primary,
              ),
              title: Text('অ্যাপ সম্পর্কে'),
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
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );
    });
  }

  void _navigateTo(MainController controller, int index) {
    controller.changePage(index);
    Get.back();
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Get.theme.colorScheme.primary,
            Get.theme.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Get.theme.colorScheme.onPrimary,
            child: Icon(
              Icons.person,
              size: 40,
              color: Get.theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'স্বাগতম!',
            style: Get.theme.textTheme.titleLarge?.copyWith(
              color: Get.theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'আপনার স্বাস্থ্যের যত্ন নিন',
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              color: Get.theme.colorScheme.onPrimary.withOpacity(0.8),
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
        color: isSelected
            ? Get.theme.colorScheme.primary
            : Get.theme.colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: Get.theme.textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? Get.theme.colorScheme.primary
              : Get.theme.colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
      tileColor: isSelected
          ? Get.theme.colorScheme.primaryContainer.withOpacity(0.3)
          : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
