import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ushud_khial/core/database/medicine_db.dart';
import 'package:ushud_khial/data/models/medicine_model.dart';

class ReminderController extends GetxController {
  final MedicineDB _medicineDB = Get.find<MedicineDB>();
  final box = GetStorage();

  var todayReminders = <MedicineModel>[].obs;
  var isLoading = true.obs;

  // GetStorage এ যে কী-তে খাওয়ার তথ্য সংরক্ষণ করা হবে
  final String _takenMedicineKey = 'taken_medicines';

  @override
  void onInit() {
    super.onInit();
    fetchTodayReminders();
  }

  void fetchTodayReminders() async {
    try {
      isLoading(true);
      final allMedicines = await _medicineDB.readAllMedicines();
      final today = DateTime.now();

      final todayList = allMedicines.where((medicine) {
        // শুরুর তারিখ আজকের আগে বা আজ এবং শেষ তারিখ আজকের পরে বা আজ কিনা
        final isDateValid =
            medicine.startDate.isBefore(today) ||
            medicine.startDate.isAtSameMomentAs(today);
        final isNotExpired =
            medicine.endDate.isAfter(today) ||
            medicine.endDate.isAtSameMomentAs(today);
        return medicine.isActive && isDateValid && isNotExpired;
      }).toList();

      todayReminders.assignAll(todayList);
    } finally {
      isLoading(false);
    }
  }

  // একটি নির্দিষ্ট ওষুধের নির্দিষ্ট সময়ের ডোজ খাওয়া হয়েছে কিনা তা চেক করা
  bool isTaken(int medicineId, String time) {
    final takenMap = box.read(_takenMedicineKey) ?? {};
    final todayKey =
        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
    return takenMap[todayKey]?['${medicineId}_$time'] ?? false;
  }

  // ওষুধ খাওয়ার স্ট্যাটাস আপডেট করা
  void markAsTaken(int medicineId, String time) {
    final takenMap = box.read(_takenMedicineKey) ?? {};
    final todayKey =
        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";

    if (!takenMap.containsKey(todayKey)) {
      takenMap[todayKey] = {};
    }
    takenMap[todayKey]['${medicineId}_$time'] = true;

    box.write(_takenMedicineKey, takenMap);
    update(); // UI আপডেট করার জন্য
    Get.snackbar('সফল', 'ওষুধ খাওয়ার তথ্য সংরক্ষণ করা হয়েছে');
  }
}
