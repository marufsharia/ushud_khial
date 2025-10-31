import 'package:get/get.dart';
import 'core/database/medicine_db.dart';
import 'core/services/notification_service.dart';
import 'core/services/permission_service.dart';
import 'modules/add_medicine/add_medicine_controller.dart';
import 'modules/analytics/analytics_controller.dart';
import 'modules/home/home_controller.dart';
import 'modules/notification_test/notification_test_controller.dart';
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
    Get.lazyPut(() => PermissionService());

    // Controllers
    Get.lazyPut(() => MainController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => AddMedicineController());
    Get.lazyPut(() => ReminderController());
    Get.lazyPut(() => AnalyticsController());
    Get.lazyPut(() => HealthRecordsController());
    Get.lazyPut(() => SettingsController());
    Get.lazyPut(() => NotificationTestController());
  }
}
