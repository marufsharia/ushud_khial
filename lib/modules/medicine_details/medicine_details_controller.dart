import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ushud_khial/core/database/medicine_db.dart';
import 'package:ushud_khial/data/models/medicine_model.dart';
import 'package:ushud_khial/modules/home/home_controller.dart';

class MedicineDetailsController extends GetxController {
  final MedicineDB _medicineDB = Get.find<MedicineDB>();
  final MedicineModel initialMedicine;

  // Reactive medicine
  final medicine = Rxn<MedicineModel>();

  // Stock controller
  late TextEditingController stockController;

  MedicineDetailsController({required this.initialMedicine}) {
    medicine.value = initialMedicine;
    stockController = TextEditingController(
      text: initialMedicine.currentStock.toString(),
    );
  }

  @override
  void onClose() {
    stockController.dispose();
    super.onClose();
  }

  // Medicine color
  Color get medicineColor {
    final colors = [
      Colors.teal,
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.purple,
      Colors.green,
      Colors.pink,
      Colors.indigo,
    ];
    return medicine.value != null
        ? colors[medicine.value!.color.clamp(0, colors.length - 1)]
        : Colors.teal;
  }

  // Stock status text
  String get stockStatusText {
    if (medicine.value == null) return 'অজানা';
    final stock = medicine.value!.currentStock;
    if (stock == 0) return 'স্টক শেষ';
    if (stock <= medicine.value!.refillThreshold) return 'শীঘ্রই কিনুন';
    return 'পর্যাপ্ত স্টক';
  }

  // Stock status color
  Color get stockStatusColor {
    if (medicine.value == null) return Colors.grey;
    final stock = medicine.value!.currentStock;
    if (stock == 0) return Colors.red;
    if (stock <= medicine.value!.refillThreshold) return Colors.orange;
    return Colors.green;
  }

  // Update stock
  void showUpdateStockDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('স্টক আপডেট করুন'),
        content: TextField(
          controller: stockController,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'নতুন স্টক সংখ্যা',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('বাতিল')),
          FilledButton(
            onPressed: () async {
              final newStock = int.tryParse(stockController.text);
              if (newStock != null && newStock >= 0) {
                await updateStock(newStock);
                Get.back(); // Close dialog after update
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

    final updatedMedicine = medicine.value!.copyWith(currentStock: newStock);
    await _medicineDB.update(updatedMedicine);
    medicine.value = updatedMedicine;

    // Update home page
    Get.find<HomeController>().fetchMedicines();

    Get.snackbar(
      'সফল',
      'স্টক সফলভাবে আপডেট হয়েছে',
      backgroundColor: Colors.green,
    );
  }

  // Toggle active/inactive
  Future<void> toggleStatus() async {
    if (medicine.value == null) return;

    final updatedMedicine = medicine.value!.copyWith(
      isActive: !medicine.value!.isActive,
    );
    await _medicineDB.update(updatedMedicine);
    medicine.value = updatedMedicine;

    Get.find<HomeController>().fetchMedicines();

    Get.snackbar(
      'সফল',
      updatedMedicine.isActive
          ? 'ওষুধটি চালু করা হয়েছে'
          : 'ওষুধটি বন্ধ করা হয়েছে',
      backgroundColor: Colors.green,
    );
  }

  // Delete medicine
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
        Get.back(); // Close dialog first
        final id = medicine.value!.id!;
        await _medicineDB.delete(id);
        medicine.value = null; // Clear local obs
        Get.find<HomeController>().fetchMedicines();
        Get.back(); // Close dialog
        Get.back(); // Close details page
        Get.snackbar(
          'সফল',
          'ওষুধটি মুছে ফেলা হয়েছে',
          backgroundColor: Colors.green,
        );
      },
    );
  }
}
