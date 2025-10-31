import 'package:get/get.dart';

import '../../core/services/notification_service.dart';
import '../reminder/reminder_controller.dart';
import 'add_medicine_controller.dart';

class AddMedicineBanding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationService>(() => NotificationService());
    Get.lazyPut(() => AddMedicineController());
    Get.lazyPut(() => ReminderController()); // নতুন কন্ট্রোলার
  }
}
