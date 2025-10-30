import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:ushud_khial/core/database/medicine_db.dart';
import 'package:ushud_khial/data/models/medicine_model.dart';

class HealthRecordsController extends GetxController {
  final MedicineDB _medicineDB = Get.find<MedicineDB>();
  final box = GetStorage();

  var records = <String, Map<String, bool>>{}
      .obs; // {date: {medicineId_time: takenStatus}}
  var medicines = <MedicineModel>[].obs;
  var isLoading = true.obs;

  final String _takenMedicineKey = 'taken_medicines';

  @override
  void onInit() {
    super.onInit();
    fetchAllMedicines();
    fetchRecords();
  }

  void fetchAllMedicines() async {
    medicines.assignAll(await _medicineDB.readAllMedicines());
  }

  void fetchRecords() {
    isLoading(true);

    // GetStorage থেকে ডেটা Map<String, dynamic> হিসেবে পড়ুন
    final allRecords =
        box.read(_takenMedicineKey) as Map<String, dynamic>? ?? {};

    // একটি নতুন খালি ম্যাপ তৈরি করুন সঠিক টাইপের
    final Map<String, Map<String, bool>> tempRecords = {};

    // পড়া ডেটার উপর দিয়ে লুপ চালান
    allRecords.forEach((dateKey, dayRecords) {
      // dayRecords হল dynamic, কিন্তু আমরা জানি এটি একটি ম্যাপ
      if (dayRecords is Map<String, dynamic>) {
        // ভেতরের ম্যাপটিকে Map<String, bool> এ কাস্ট করুন এবং নতুন ম্যাপে যোগ করুন
        tempRecords[dateKey] = dayRecords.cast<String, bool>();
      }
    });

    // সঠিকভাবে কনভার্ট করা ডেটা দিয়ে records ভেরিয়েবলটি আপডেট করুন
    records.assignAll(tempRecords);

    isLoading(false);
  }

  // ওষুধের ID থেকে নাম খুঁজে বের করা
  String getMedicineName(int id) {
    final medicine = medicines.firstWhereOrNull((med) => med.id == id);
    return medicine?.name ?? 'অজানা ওষুধ';
  }

  // ডেটা ক্লিয়ার করার জন্য
  void clearAllRecords() {
    box.remove(_takenMedicineKey);
    fetchRecords();
    Get.snackbar('সফল', 'সব রেকর্ড মুছে ফেলা হয়েছে');
  }
}
