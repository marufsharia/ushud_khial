import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ushud_khial/core/database/medicine_db.dart';
import 'package:ushud_khial/data/models/medicine_model.dart';
import 'package:ushud_khial/modules/home/home_controller.dart';

class MedicineDetailsController extends GetxController {
  late final MedicineDB _medicineDB;
  final Rx<MedicineModel?> medicine = Rx<MedicineModel?>(null);
  late final TextEditingController stockController;
  final RxBool isLoading = false.obs;

  MedicineDetailsController() {
    _medicineDB = MedicineDB.instance; // ✅ FIXED
    stockController = TextEditingController();
  }

  Future<void> fetchMedicine(int id) async {
    try {
      isLoading(true);
      final data = await _medicineDB.readMedicine(id);
      medicine.value = data;
      debugPrint('Medicine fetched: $data');
      isLoading(false);
    } catch (e) {
      Get.snackbar(
        'ত্রুটি',
        'ওষুধটি খুঁজে পাওয়া যায়নি',
        backgroundColor: Colors.redAccent,
      );
    }
  }

  @override
  void onClose() {
    stockController.dispose();
    super.onClose();
  }

  Color get medicineColor {
    const colors = [
      Colors.teal,
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.purple,
      Colors.green,
      Colors.pink,
      Colors.indigo,
    ];
    final index = medicine.value?.color ?? 0;
    return colors[index.clamp(0, colors.length - 1)];
  }

  String get stockStatusText {
    final stock = medicine.value?.currentStock ?? 0;
    final threshold = medicine.value?.refillThreshold ?? 10;
    if (stock == 0) return 'স্টক শেষ';
    if (stock <= threshold) return 'শীঘ্রই কিনুন';
    return 'পর্যাপ্ত স্টক';
  }

  Color get stockStatusColor {
    final stock = medicine.value?.currentStock ?? 0;
    final threshold = medicine.value?.refillThreshold ?? 10;
    if (stock == 0) return Colors.red;
    if (stock <= threshold) return Colors.orange;
    return Colors.green;
  }

  void showUpdateStockDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('স্টক আপডেট করুন'),
        content: TextField(
          controller: stockController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'নতুন স্টক সংখ্যা',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('বাতিল')),
          FilledButton(
            onPressed: () async {
              final newStock = int.tryParse(stockController.text);
              if (newStock != null && newStock >= 0) {
                await updateStock(newStock);
                Get.back();
              } else {
                Get.snackbar(
                  'ত্রুটি',
                  'একটি বৈধ সংখ্যা লিখুন',
                  backgroundColor: Colors.redAccent,
                );
              }
            },
            child: const Text('আপডেট'),
          ),
        ],
      ),
    );
  }

  Future<void> updateStock(int newStock) async {
    if (medicine.value == null) return;
    final updated = medicine.value!.copyWith(currentStock: newStock);
    await _medicineDB.update(updated);
    medicine.value = updated;
    Get.find<HomeController>().fetchMedicines();
    Get.snackbar('সফল', 'স্টক আপডেট হয়েছে', backgroundColor: Colors.green);
  }

  Future<void> toggleStatus() async {
    if (medicine.value == null) return;
    final updated = medicine.value!.copyWith(
      isActive: !medicine.value!.isActive,
    );
    await _medicineDB.update(updated);
    medicine.value = updated;
    Get.find<HomeController>().fetchMedicines();
    Get.snackbar(
      'সফল',
      updated.isActive ? 'ওষুধটি চালু করা হয়েছে' : 'ওষুধটি বন্ধ করা হয়েছে',
      backgroundColor: Colors.green,
    );
  }

  void deleteMedicine() {
    if (medicine.value == null) return;

    Get.defaultDialog(
      title: 'ওষুধ মুছে ফেলুন',
      middleText:
          'আপনি কি ${medicine.value!.name} মুছে ফেলতে চান? এই কাজটি পূর্বাবস্থায় ফেরানো যাবে না।',
      textCancel: 'বাতিল',
      textConfirm: 'হ্যাঁ, মুছে ফেলুন',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        final id = medicine.value!.id!;
        await _medicineDB.delete(id);
        medicine.value = null;
        Get.find<HomeController>().fetchMedicines();
        Get.back(); // close dialog
        Get.back(); // close details screen
        Get.snackbar(
          'সফল',
          'ওষুধটি মুছে ফেলা হয়েছে',
          backgroundColor: Colors.green,
        );
      },
    );
  }
}
