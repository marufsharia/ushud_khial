import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ushud_khial/core/database/medicine_db.dart';
import 'package:ushud_khial/data/models/medicine_model.dart';
import 'package:ushud_khial/modules/home/home_controller.dart';

class MedicineDetailsView extends StatelessWidget {
  final MedicineModel medicine;

  const MedicineDetailsView({super.key, required this.medicine});

  Color getMedicineColor() {
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
    return colors[medicine.color.clamp(0, colors.length - 1)];
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = getMedicineColor();
    return Scaffold(
      appBar: AppBar(title: Text(medicine.name), backgroundColor: cardColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard('ওষুধের নাম', medicine.name),
            _buildDetailCard('ডোজ', medicine.dosage),
            _buildDetailCard(
              'ডাক্তারের নাম',
              medicine.doctorName ?? 'দেওয়া হয়নি',
            ),
            _buildDetailCard('যোগাযোগ', medicine.doctorContact ?? 'দেওয়া হয়নি'),
            _buildDetailCard(
              'দৈনিক খাওয়ার সংখ্যা',
              '${medicine.frequency} বার',
            ),
            _buildDetailCard('সময়', medicine.times.join(', ')),
            _buildDetailCard(
              'শুরুর তারিখ',
              '${medicine.startDate.day}/${medicine.startDate.month}/${medicine.startDate.year}',
            ),
            _buildDetailCard(
              'শেষ তারিখ',
              '${medicine.endDate.day}/${medicine.endDate.month}/${medicine.endDate.year}',
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _toggleMedicineStatus(medicine),
                    icon: Icon(
                      medicine.isActive ? Icons.pause : Icons.play_arrow,
                    ),
                    label: Text(medicine.isActive ? 'বন্ধ করুন' : 'চালু করুন'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _deleteMedicine(medicine),
                    icon: Icon(Icons.delete),
                    label: Text('মুছে ফেলুন'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String value) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title: ',
              style: GoogleFonts.hindSiliguri(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.hindSiliguri(color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleMedicineStatus(MedicineModel medicine) async {
    final db = Get.find<MedicineDB>();
    final updatedMedicine = medicine.copyWith(isActive: !medicine.isActive);
    await db.update(updatedMedicine);
    Get.find<HomeController>().fetchMedicines();
    Get.back();
    Get.snackbar(
      'সফল',
      medicine.isActive ? 'ওষুধটি বন্ধ করা হয়েছে' : 'ওষুধটি চালু করা হয়েছে',
    );
  }

  void _deleteMedicine(MedicineModel medicine) {
    Get.defaultDialog(
      title: 'ওষুধ মুছে ফেলুন',
      middleText: 'আপনি কি ${medicine.name} মুছে ফেলতে চান?',
      onConfirm: () async {
        Get.back();
        await Get.find<MedicineDB>().delete(medicine.id!);
        Get.find<HomeController>().fetchMedicines();
        Get.back(); // Details পেজ থেকেও ফিরে যাওয়া
        Get.snackbar('সফল', 'ওষুধটি মুছে ফেলা হয়েছে');
      },
    );
  }
}
