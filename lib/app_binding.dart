import 'package:get/get.dart';
import 'package:ushud_khial/core/database/medicine_db.dart';
import 'package:ushud_khial/core/services/notification_service.dart';
import 'package:ushud_khial/modules/add_medicine/add_medicine_controller.dart';
import 'package:ushud_khial/modules/home/home_controller.dart';

import 'modules/health_records/health_records_controller.dart';
import 'modules/main/main_controller.dart';
import 'modules/reminder/reminder_controller.dart';
import 'modules/settings/settings_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Core Services & Database
    Get.lazyPut<MedicineDB>(() => MedicineDB.instance);
    Get.lazyPut<NotificationService>(() => NotificationService());

    // Controllers
    // Controllers
    Get.lazyPut(() => MainController()); // নতুন কন্ট্রোলার
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => AddMedicineController());
    Get.lazyPut(() => ReminderController()); // নতুন কন্ট্রোলার
    Get.lazyPut(() => HealthRecordsController()); // যোগ করুন
    Get.lazyPut(() => SettingsController()); // যোগ করুন
  }
}
