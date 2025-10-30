import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ushud_khial/core/config/app_routes.dart'; // নতুন ইমপোর্ট
import 'package:ushud_khial/core/widgets/custom_app_bar.dart'; // নতুন ইমপোর্ট
import '../../core/widgets/lib/core/widgets/app_drawer.dart';
import '../home/home_view.dart';
import '../reminder/reminder_view.dart';
import '../health_records/health_records_view.dart';
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
    return Obx(
      () => Scaffold(
        // নতুন CustomAppBar ব্যবহার করা হচ্ছে
        appBar: CustomAppBar(
          title: _getPageTitle(controller.currentIndex.value),
          // Drawer খোলার জন্য মেনু আইকন স্বয়ংক্রিয়ভাবে যোগ হবে
        ),
        // নতুন AppDrawer যোগ করা হচ্ছে
        drawer: AppDrawer(),

        // ব্যাকগ্রাউন্ড কালার পরিবর্তন করে আরও সুন্দর লুক দেওয়া হলো
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: _pages,
        ),
        bottomNavigationBar: _buildBottomNavBar(),
        floatingActionButton: controller.currentIndex.value == 0
            ? FloatingActionButton(
                onPressed: () => Get.toNamed(AppRoutes.addMedicine),
                backgroundColor: Get.theme.primaryColor,
                tooltip: 'নতুন ওষুধ যোগ করুন',
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
        return 'স্বাস্থ্য রেকর্ড';
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
      selectedItemColor: Get.theme.primaryColor,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
      unselectedLabelStyle: GoogleFonts.hindSiliguri(),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'ওষুধের তালিকা',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'রিমাইন্ডার'),
        BottomNavigationBarItem(
          icon: Icon(Icons.folder_shared),
          label: 'রেকর্ড',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'সেটিংস'),
      ],
    );
  }
}
