import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ushud_khial/modules/add_medicine/add_medicine_controller.dart';

class AddMedicineView extends GetView<AddMedicineController> {
  const AddMedicineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('নতুন ওষুধ যোগ করুন')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(controller.nameController, 'ওষুধের নাম'),
            const SizedBox(height: 16),
            _buildTextField(
              controller.dosageController,
              'ডোজ (যেমন: ১টি ট্যাবলেট)',
            ),
            const SizedBox(height: 16),
            _buildFrequencySelector(),
            const SizedBox(height: 16),
            _buildTimeSelector(context),
            const SizedBox(height: 16),
            _buildDateSelector(context),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => controller.saveMedicine(context),
              child: Text('ওষুধ সংরক্ষণ করুন'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        labelStyle: GoogleFonts.hindSiliguri(),
      ),
      style: GoogleFonts.hindSiliguri(),
    );
  }

  Widget _buildFrequencySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('দৈনিক কতবার?', style: GoogleFonts.hindSiliguri(fontSize: 16)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [1, 2, 3].map((freq) {
            return Obx(
              () => ChoiceChip(
                label: Text('$freq বার', style: GoogleFonts.hindSiliguri()),
                selected: controller.selectedFrequency.value == freq,
                onSelected: (selected) {
                  controller.selectedFrequency.value = freq;
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'সময় নির্বাচন করুন',
          style: GoogleFonts.hindSiliguri(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: controller.selectedTimes.map((time) {
              return Chip(
                label: Text(
                  time.format(context),
                  style: GoogleFonts.hindSiliguri(),
                ),
                onDeleted: () => controller.removeTime(
                  controller.selectedTimes.indexOf(time),
                ),
              );
            }).toList(),
          ),
        ),
        TextButton.icon(
          onPressed: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) {
              controller.addTime(picked);
            }
          },
          icon: const Icon(Icons.access_time),
          label: Text('সময় যোগ করুন', style: GoogleFonts.hindSiliguri()),
        ),
      ],
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => ListTile(
            title: Text('শুরুর তারিখ', style: GoogleFonts.hindSiliguri()),
            subtitle: Text(
              '${controller.startDate.value.day}/${controller.startDate.value.month}/${controller.startDate.value.year}',
              style: GoogleFonts.hindSiliguri(),
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => controller.selectDate(context, true),
          ),
        ),
        Obx(
          () => ListTile(
            title: Text('শেষ তারিখ', style: GoogleFonts.hindSiliguri()),
            subtitle: Text(
              '${controller.endDate.value.day}/${controller.endDate.value.month}/${controller.endDate.value.year}',
              style: GoogleFonts.hindSiliguri(),
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => controller.selectDate(context, false),
          ),
        ),
      ],
    );
  }
}
