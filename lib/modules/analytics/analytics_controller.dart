import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ushud_khial/core/database/medicine_db.dart';
import 'package:ushud_khial/data/models/medicine_model.dart';

class AnalyticsController extends GetxController {
  final MedicineDB _medicineDB = Get.find<MedicineDB>();
  final box = GetStorage();
  final String _takenMedicineKey = 'taken_medicines';

  var adherencePercentage = 0.0.obs;
  var totalMedicinesTaken = 0.obs;
  var totalMedicinesMissed = 0.obs;
  var lowStockMedicines = <MedicineModel>[].obs;
  var weeklyData = <int, int>{}.obs; // {dayOfWeek: takenCount}

  @override
  void onInit() {
    super.onInit();
    calculateAnalytics();
  }

  @override
  void onReady() {
    calculateAnalytics();
    super.onReady();
  }

  Future<void> calculateAnalytics() async {
    final allRecords =
        box.read(_takenMedicineKey) as Map<String, dynamic>? ?? {};
    final allMedicines = await _medicineDB.readAllMedicines();
    int taken = 0;
    int missed = 0;

    // গত ৭ দিনের ডেটা প্রসেস করা
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final day = now.subtract(Duration(days: i));
      final dayKey = "${day.day}-${day.month}-${day.year}";
      final dayRecords = allRecords[dayKey] as Map<String, dynamic>? ?? {};
      taken += dayRecords.length;
    }

    // মোট সম্ভাব্য ডোজ হিসাব করা (জটিল, সরলীকৃত হিসাব)
    int totalPossibleDoses = 0;
    for (var med in allMedicines) {
      // parse double to int
      final frequency = int.parse(med.frequency.toString());
      totalPossibleDoses += frequency * 7;
    }

    totalMedicinesTaken.value = taken;
    totalMedicinesMissed.value = (totalPossibleDoses - taken)
        .clamp(0, double.infinity)
        .toInt();

    if (totalPossibleDoses > 0) {
      adherencePercentage.value = (taken / totalPossibleDoses) * 100;
    }

    // কম স্টকের ওষুধ খুঁজে বের করা
    lowStockMedicines.assignAll(
      allMedicines.where((med) => med.currentStock <= med.refillThreshold),
    );
  }
}
