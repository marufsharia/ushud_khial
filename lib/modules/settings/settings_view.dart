import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ushud_khial/core/config/constants.dart';

import '../../core/services/permission_service.dart';
import 'settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final permissionService = Get.find<PermissionService>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [_buildSettingsSection(permissionService, context)],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Text(
        'সেটিংস',
        style: Get.theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Get.theme.primaryColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSettingsSection(permissionService, context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _buildSettingsCard(
            children: [
              Obx(
                () => SwitchListTile(
                  title: Text('নোটিফিকেশন'),
                  subtitle: Text('ওষুধের রিমাইন্ডার পান'),
                  secondary: Icon(
                    Icons.notifications_active,
                    color: Get.theme.colorScheme.primary,
                  ),
                  value: controller.isNotificationEnabled.value,
                  onChanged: controller.toggleNotification,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSettingsCard(
            children: [
              ListTile(
                leading: const Icon(Icons.notifications_active),
                title: const Text('পারমিশন স্ট্যাটাস'),
                subtitle: const Text('অ্যাপের প্রয়োজনীয় পারমিশন পরীক্ষা করুন'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Get.to(() => const PermissionStatusView()),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSettingsCard(
            children: [
              Obx(
                () => SwitchListTile(
                  title: Text('ডার্ক মোড'),
                  subtitle: Text('অ্যাপের থিম পরিবর্তন করুন'),
                  secondary: Icon(
                    controller.isDarkMode.value
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: Get.theme.colorScheme.primary,
                  ),
                  value: controller.isDarkMode.value,
                  onChanged: controller.toggleTheme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSettingsCard(
            children: [
              ListTile(
                title: Text(
                  'সব ডেটা মুছে ফেলুন',
                  style: TextStyle(color: Get.theme.colorScheme.error),
                ),
                subtitle: Text('ওষুধ ও রেকর্ড সব মুছে যাবে'),
                leading: Icon(
                  Icons.delete_forever,
                  color: Get.theme.colorScheme.error,
                ),
                onTap: controller.clearAllData,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSettingsCard(
            children: [
              ListTile(
                title: Text('অ্যাপ সম্পর্কে'),
                subtitle: Text('ভার্সন: ${AppConstants.appVersion}'),
                leading: Icon(
                  Icons.info_outline,
                  color: Get.theme.colorScheme.primary,
                ),
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
                      Text('Developed By : Maruf Sharia'),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  /*Widget _buildPermissionCard(PermissionService permissionService) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications_active),
            title: const Text('পারমিশন স্ট্যাটাস'),
            subtitle: const Text('অ্যাপের প্রয়োজনীয় পারমিশন পরীক্ষা করুন'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.to(() => const PermissionStatusView()),
          ),
        ],
      ),
    );
  }*/
}

// একটি নতুন ভিউ যেখাবে পারমিশনের বর্তমান অবস্থা
class PermissionStatusView extends StatelessWidget {
  const PermissionStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    final permissionService = Get.find<PermissionService>();

    return Scaffold(
      appBar: AppBar(title: const Text('পারমিশন স্ট্যাটাস')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('নোটিফিকেশন'),
              subtitle: const Text('অ্যাপটি রিমাইন্ডার পাঠানোর জন্য প্রয়োজনীয়'),
              trailing: FilledButton(
                onPressed: permissionService.checkNotificationPermission,
                child: const Text('চেক করুন'),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('ব্যাটারি অপ্টিমাইজেশন'),
              subtitle: const Text('ব্যাকগ্রাউন্ডে সুচারভাবে কাজ করার জন্য'),
              trailing: FilledButton(
                onPressed: permissionService.checkBatteryOptimization,
                child: const Text('চেক করুন'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
