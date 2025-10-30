import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ushud_khial/modules/health_records/health_records_controller.dart';

class HealthRecordsView extends GetView<HealthRecordsController> {
  const HealthRecordsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.records.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 80, color: Colors.grey.shade400),
                SizedBox(height: 20),
                Text(
                  'কোনো রেকর্ড পাওয়া যায়নি',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 20,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        // তারিখ অনুযায়ী সাজানোর জন্য কীগুলোকে সাজিয়ে নেওয়া
        final sortedDates = controller.records.keys.toList()
          ..sort((a, b) => b.compareTo(a)); // সবচেয়ে নতুন উপরে

        return ListView.builder(
          itemCount: sortedDates.length,
          itemBuilder: (context, index) {
            final dateKey = sortedDates[index];
            final dayRecords = controller.records[dateKey]!;
            return RecordExpansionTile(date: dateKey, records: dayRecords);
          },
        );
      }),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    Get.defaultDialog(
      title: 'সব রেকর্ড মুছে ফেলুন',
      titleStyle: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
      middleText:
          'আপনি কি নিশ্চিত যে আপনি সব স্বাস্থ্য রেকর্ড মুছে ফেলতে চান? এই কাজটি আর পূর্বাবস্থায় ফেরানো যাবে না।',
      middleTextStyle: GoogleFonts.hindSiliguri(),
      textConfirm: 'হ্যাঁ, মুছে ফেলুন',
      textCancel: 'বাতিল',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        controller.clearAllRecords();
      },
    );
  }
}

class RecordExpansionTile extends StatelessWidget {
  final String date;
  final Map<String, bool> records;

  const RecordExpansionTile({
    super.key,
    required this.date,
    required this.records,
  });

  String _formatDate(String dateKey) {
    final parts = dateKey.split('-');
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);
    final dateTime = DateTime(year, month, day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (dateTime == today) {
      return 'আজ, ${DateFormat('d MMMM, yyyy', 'bn_BD').format(dateTime)}';
    } else if (dateTime == yesterday) {
      return 'গতকাল, ${DateFormat('d MMMM, yyyy', 'bn_BD').format(dateTime)}';
    } else {
      return DateFormat('EEEE, d MMMM, yyyy', 'bn_BD').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HealthRecordsController>();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        title: Text(
          _formatDate(date),
          style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
        ),
        children: records.entries.map((entry) {
          final keyParts = entry.key.split('_');
          final medicineId = int.parse(keyParts[0]);
          final time = keyParts[1];
          final medicineName = controller.getMedicineName(medicineId);

          return ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title: Text(medicineName, style: GoogleFonts.hindSiliguri()),
            subtitle: Text('সময়: $time', style: GoogleFonts.hindSiliguri()),
          );
        }).toList(),
      ),
    );
  }
}
