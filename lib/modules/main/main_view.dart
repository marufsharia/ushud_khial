import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ushud_khial/core/config/app_routes.dart';
import '../health_records/health_records_view.dart';
import '../home/home_view.dart';
import '../reminder/reminder_view.dart';
import '../settings/settings_view.dart';
import 'main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  final List<Widget> _pages = const [
    HomeView(),
    ReminderView(),
    HealthRecordsView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      builder: (controller) {
        return Scaffold(
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: _pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changePage,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.teal,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: GoogleFonts.hindSiliguri(
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: GoogleFonts.hindSiliguri(),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'ওষুধের তালিকা',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.alarm),
                label: 'আজকের রিমাইন্ডার',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.folder_shared),
                label: 'রেকর্ড',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'সেটিংস',
              ),
            ],
          ),
          floatingActionButton: controller.currentIndex.value == 0
              ? FloatingActionButton(
                  onPressed: () => Get.toNamed(AppRoutes.addMedicine),
                  child: const Icon(Icons.add),
                  tooltip: 'নতুন ওষুধ যোগ করুন',
                )
              : null, // শুধুমাত্র হোম পেজে ফ্লোটিং বাটন দেখাবে
        );
      },
    );
  }
}
