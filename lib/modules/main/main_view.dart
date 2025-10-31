import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ushud_khial/core/config/app_routes.dart';
import 'package:ushud_khial/core/widgets/custom_app_bar.dart';

import '../../core/widgets/app_drawer.dart';
import '../analytics/analytics_view.dart';
import '../home/home_view.dart';
import '../reminder/reminder_view.dart';
import '../settings/settings_view.dart';
import 'main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  final List<Widget> _pages = const [
    HomeView(),
    ReminderView(),
    AnalyticsView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: CustomAppBar(
          title: _getPageTitle(controller.currentIndex.value),
        ),
        drawer: const AppDrawer(),
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        body: Container(
          // বডির জন্য একটি সূক্ষ্ম কার্ড ডিজাইন
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Get.theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: IndexedStack(
              index: controller.currentIndex.value,
              children: _pages,
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavBar(),
        floatingActionButton: controller.currentIndex.value == 0
            ? FloatingActionButton(
                onPressed: () => Get.toNamed(AppRoutes.addMedicine),
                backgroundColor: Get.theme.colorScheme.primary,
                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,
      ),
    );
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'ওষুধের তালিকা';
      case 1:
        return 'আজকের রিমাইন্ডার';
      case 2:
        return 'অ্যানালিটিক্স';
      case 3:
        return 'সেটিংস';
      default:
        return 'ওষুধের খেয়াল';
    }
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: controller.currentIndex.value,
      onTap: controller.changePage,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Get.theme.cardColor,
      selectedItemColor: Get.theme.colorScheme.primary,
      unselectedItemColor: Get.theme.unselectedWidgetColor,
      selectedLabelStyle: Get.theme.textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: Get.theme.textTheme.bodySmall,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'ওষুধের তালিকা',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'রিমাইন্ডার'),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          label: 'অ্যানালিটিক্স',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'সেটিংস'),
      ],
    );
  }
}
