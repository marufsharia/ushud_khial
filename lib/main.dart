import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app_binding.dart';
import 'core/config/app_routes.dart';
import 'core/config/app_theme.dart';
import 'core/services/notification_service.dart';
import 'core/services/permission_service.dart';
import 'modules/add_medicine/add_medicine_binding.dart';
import 'modules/add_medicine/add_medicine_view.dart';
import 'modules/main/main_view.dart';
import 'modules/medicine_details/medicine_details_binding.dart';
import 'modules/medicine_details/medicine_details_view.dart';
import 'modules/settings/settings_controller.dart';

/// Initializes the app and necessary services.
void main() async {
  // Ensures that widget binding is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes date formatting for Bengali locale.
  await initializeDateFormatting('bn_BD', null);

  // Initializes local storage for simple data persistence.
  await GetStorage.init();

  // Initializes the notification service.
  await NotificationService().initialize();

  // Initializes the permission service and checks for necessary permissions.
  final permissionService = Get.put(PermissionService());
  await permissionService.checkNotificationPermission();
  await permissionService.checkBatteryOptimization();
  // Sets up the app's dependency injection.
  AppBinding().dependencies();

  runApp(const MyApp());
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.put(SettingsController());

    return GetMaterialApp(
      title: 'ওষুধের খেয়াল',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settingsController.isDarkMode.value
          ? ThemeMode.dark
          : ThemeMode.light,
      initialRoute: AppRoutes.main,
      // Defines the app's routes and pages.
      getPages: [
        GetPage(
          name: AppRoutes.main,
          page: () => const MainView(),
          binding: AppBinding(),
        ),
        GetPage(
          name: AppRoutes.addMedicine,
          page: () => const AddMedicineView(),
          binding: AddMedicineBanding(),
        ),
        // GetPage(
        //   name: AppRoutes.detailsMedicine,
        //   page: () => MedicineDetailsView(id: 1),
        //   binding: MedicineDetailsBanding(),
        // ),
        GetPage(
          name: AppRoutes.detailsMedicine,
          page: () {
            final parameters = Get.parameters;
            final id = int.parse(
              parameters['id'] != null
                  ? parameters['id']!
                  : Get.arguments['id'].toString(),
            );

            if (id == null || id == 0) {
              Get.snackbar('ত্রুটি', 'সঠিক ID প্রদান করুন');
              return const SizedBox.shrink();
            }

            return MedicineDetailsView(id: id);
          },
          binding: MedicineDetailsBanding(),
        ),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
