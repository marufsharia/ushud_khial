import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ushud_khial/app_binding.dart';

import 'core/config/app_routes.dart';
import 'core/config/app_theme.dart';
import 'core/services/notification_service.dart';
import 'modules/add_medicine/add_mediciine_binding.dart';
import 'modules/add_medicine/add_medicine_view.dart';
import 'modules/main/main_view.dart';
import 'modules/settings/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('bn_BD', null);
  await GetStorage.init(); // Get Storage ইনিশিয়ালাইজ করা
  await NotificationService().init(); // নোটিফিকেশন সার্ভিস ইনিশিয়ালাইজ করা
  AppBinding().dependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.put(SettingsController());
    return Obx(() {
      return GetMaterialApp(
        title: 'ওষুধের খেয়াল',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: settingsController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        initialRoute: AppRoutes.main,
        // ইনিশিয়াল রুট পরিবর্তন
        getPages: [
          GetPage(
            name: AppRoutes.main,
            page: () => MainView(),
            binding: AppBinding(),
          ),
          GetPage(
            name: AppRoutes.addMedicine,
            page: () => AddMedicineView(),
            binding: AddMedicineBanding(),
          ), // বাইন্ডিং যোগ করা হলো
          // অন্যান্য পেজগুলো এখন MainView থেকে নেভিগেট করা হবে
        ],
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
