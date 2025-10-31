import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ushud_khial/core/widgets/custom_app_bar.dart';
import 'medicine_details_controller.dart';

class MedicineDetailsView extends GetView<MedicineDetailsController> {
  const MedicineDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final medicine = controller.medicine.value;

      // Loading state
      if (medicine == null) {
        return const Scaffold(
          appBar: CustomAppBar(title: 'লোড হচ্ছে...'),
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: CustomAppBar(title: medicine.name),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(medicine),
              const SizedBox(height: 16),
              _buildInfoSection(medicine),
              const SizedBox(height: 20),
              _buildActionSection(medicine),
            ],
          ),
        ),
      );
    });
  }

  // Header section
  Widget _buildHeader(dynamic medicine) {
    final cardColor = controller.medicineColor;
    final stockColor = controller.stockStatusColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medication,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.name,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      medicine.dosage,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: stockColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: stockColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStockInfo(
                  'বর্তমান স্টক',
                  '${medicine.currentStock} টি',
                  stockColor,
                ),
                _buildStockInfo(
                  'স্ট্যাটাস',
                  controller.stockStatusText,
                  stockColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockInfo(String title, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.hindSiliguri(color: Colors.grey.shade700),
        ),
        Text(
          value,
          style: GoogleFonts.hindSiliguri(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // Info section
  Widget _buildInfoSection(dynamic medicine) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildInfoTile(
            Icons.person,
            'ডাক্তারের নাম',
            medicine.doctorName ?? 'দেওয়া হয়নি',
          ),
          _buildInfoTile(
            Icons.phone,
            'যোগাযোগ',
            medicine.doctorContact ?? 'দেওয়া হয়নি',
          ),
          _buildInfoTile(
            Icons.repeat,
            'দৈনিক খাওয়ার সংখ্যা',
            '${medicine.frequency} বার',
          ),
          _buildInfoTile(Icons.schedule, 'সময়', medicine.times.join(', ')),
          _buildInfoTile(
            Icons.calendar_today,
            'শুরুর তারিখ',
            _formatDate(medicine.startDate),
          ),
          _buildInfoTile(
            Icons.event_available,
            'শেষ তারিখ',
            _formatDate(medicine.endDate),
          ),
          _buildInfoTile(
            Icons.notifications_active,
            'রিফিল রিমাইন্ডার',
            '${medicine.refillThreshold} টি ওষুধ থাকতে',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Get.theme.primaryColor),
      title: Text(
        title,
        style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        value,
        style: GoogleFonts.hindSiliguri(color: Colors.black54),
      ),
    );
  }

  // Action buttons
  Widget _buildActionSection(dynamic medicine) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: controller.showUpdateStockDialog,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.blue.shade100,
                foregroundColor: Colors.blue.shade700,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add_shopping_cart),
                  SizedBox(width: 8),
                  Text(
                    'স্টক আপডেট করুন',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonal(
                  onPressed: controller.toggleStatus,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: medicine.isActive
                        ? Colors.orange.shade100
                        : Colors.green.shade100,
                    foregroundColor: medicine.isActive
                        ? Colors.orange.shade700
                        : Colors.green.shade700,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(medicine.isActive ? Icons.pause : Icons.play_arrow),
                      const SizedBox(width: 8),
                      Text(
                        medicine.isActive ? 'বন্ধ করুন' : 'চালু করুন',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.tonal(
                  onPressed: controller.deleteMedicine,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.red.shade100,
                    foregroundColor: Colors.red.shade700,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.delete_outline),
                      SizedBox(width: 8),
                      Text(
                        'মুছে ফেলুন',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
