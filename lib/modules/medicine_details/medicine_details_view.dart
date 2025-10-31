import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ushud_khial/core/widgets/custom_app_bar.dart';

import '../../data/models/medicine_model.dart';
import 'medicine_details_controller.dart';

class MedicineDetailsView extends StatefulWidget {
  final int id;
  final controller = Get.find<MedicineDetailsController>();
  MedicineDetailsView({super.key, required this.id}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchMedicine(id);
    });
  }

  @override
  State<MedicineDetailsView> createState() => _MedicineDetailsViewState();
}

class _MedicineDetailsViewState extends State<MedicineDetailsView> {
  late final MedicineModel? medicine = widget.controller.medicine.value;

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while the medicine data is being fetched or is null.

    if (widget.controller.isLoading.value) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'লোড হচ্ছে...'),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Obx(() {
      return Scaffold(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        appBar: CustomAppBar(title: medicine!.name),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(medicine!),
              const SizedBox(height: 16),
              _buildInfoSection(medicine!),
              const SizedBox(height: 20),
              _buildActionSection(medicine!),
            ],
          ),
        ),
      );
    });
  }

  /// Builds the header section with the medicine icon, name, and stock status.
  Widget _buildHeader(MedicineModel medicine) {
    final cardColor = widget.controller.medicineColor;
    final stockColor = widget.controller.stockStatusColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
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
                        color: Get.theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      medicine.dosage,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 16,
                        color: Get.theme.colorScheme.onSurfaceVariant,
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
                  widget.controller.stockStatusText,
                  stockColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a row displaying stock information.
  Widget _buildStockInfo(String title, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.hindSiliguri(
            color: Get.theme.colorScheme.onSurfaceVariant,
          ),
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

  /// Builds the section with detailed information about the medicine.
  Widget _buildInfoSection(MedicineModel medicine) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
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

  /// Builds a single list tile for displaying information.
  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Get.theme.colorScheme.primary),
      title: Text(
        title,
        style: GoogleFonts.hindSiliguri(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        value,
        style: GoogleFonts.hindSiliguri(
          color: Get.theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  /// Builds the action buttons for updating stock, toggling status, and deleting.
  Widget _buildActionSection(MedicineModel medicine) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: widget.controller.showUpdateStockDialog,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Get.theme.colorScheme.secondaryContainer,
                foregroundColor: Get.theme.colorScheme.onSecondaryContainer,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_shopping_cart),
                  const SizedBox(width: 8),
                  Text(
                    'স্টক আপডেট করুন',
                    style: GoogleFonts.hindSiliguri(
                      fontWeight: FontWeight.bold,
                    ),
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
                  onPressed: widget.controller.toggleStatus,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: medicine.isActive
                        ? Get.theme.colorScheme.errorContainer
                        : Get.theme.colorScheme.primaryContainer,
                    foregroundColor: medicine.isActive
                        ? Get.theme.colorScheme.onErrorContainer
                        : Get.theme.colorScheme.onPrimaryContainer,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(medicine.isActive ? Icons.pause : Icons.play_arrow),
                      const SizedBox(width: 8),
                      Text(
                        medicine.isActive ? 'বন্ধ করুন' : 'চালু করুন',
                        style: GoogleFonts.hindSiliguri(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.tonal(
                  onPressed: widget.controller.deleteMedicine,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Get.theme.colorScheme.errorContainer,
                    foregroundColor: Get.theme.colorScheme.onErrorContainer,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.delete_outline),
                      const SizedBox(width: 8),
                      Text(
                        'মুছে ফেলুন',
                        style: GoogleFonts.hindSiliguri(
                          fontWeight: FontWeight.bold,
                        ),
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

  /// Formats a DateTime object into a string (DD/MM/YYYY).
  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
