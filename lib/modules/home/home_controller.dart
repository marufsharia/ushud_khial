import 'package:get/get.dart';
import 'package:ushud_khial/core/database/medicine_db.dart';
import 'package:ushud_khial/data/models/medicine_model.dart';

import '../reminder/reminder_controller.dart';

class HomeController extends GetxController {
  final MedicineDB _medicineDB = Get.find<MedicineDB>();
  var medicines = <MedicineModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMedicines();
  }

  void fetchMedicines() async {
    try {
      isLoading(true);
      final data = await _medicineDB.readAllMedicines();
      medicines.assignAll(data);
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteMedicine(int id) async {
    await _medicineDB.delete(id);
    fetchMedicines();
    Get.find<ReminderController>().fetchTodayReminders();
    Get.snackbar('সফল', 'ওষুধটি তালিকা থেকে মুছে ফেলা হয়েছে');
  }
}
