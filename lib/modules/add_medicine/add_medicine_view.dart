import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ushud_khial/modules/add_medicine/add_medicine_controller.dart';

class AddMedicineView extends GetView<AddMedicineController> {
  const AddMedicineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('নতুন ওষুধ যোগ করুন')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
            _buildStockSection(),
            const SizedBox(height: 16),
            _buildDoctorSection(),
            const SizedBox(height: 16),
            _buildColorPicker(),
            const SizedBox(height: 16),
            _buildFrequencySelector(),
            const SizedBox(height: 16),
            _buildTimeSelector(context),
            const SizedBox(height: 16),
            _buildDateSelector(context),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => controller.saveMedicine(context),
              child: Text(
                'ওষুধ সংরক্ষণ করুন',
                style: GoogleFonts.hindSiliguri(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController c, String label) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[100],
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
        const SizedBox(height: 8),
        Obx(
          () => Wrap(
            spacing: 12,
            children: [1, 2, 3].map((freq) {
              final selected = controller.selectedFrequency.value == freq;
              return ChoiceChip(
                label: Text(
                  '$freq বার',
                  style: GoogleFonts.hindSiliguri(
                    color: selected ? Colors.white : Colors.black,
                  ),
                ),
                checkmarkColor: selected ? Colors.white : Colors.black,
                selected: selected,
                selectedColor: Colors.teal,
                backgroundColor: Colors.grey[200],
                onSelected: (_) => controller.selectedFrequency.value = freq,
              );
            }).toList(),
          ),
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
            spacing: 8,
            runSpacing: 4,
            children: controller.selectedTimes.map((time) {
              return Chip(
                label: Text(
                  time.format(context),
                  style: GoogleFonts.hindSiliguri(),
                ),
                onDeleted: () => controller.removeTime(
                  controller.selectedTimes.indexOf(time),
                ),
                backgroundColor: Colors.teal[100],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) controller.addTime(picked);
          },
          icon: const Icon(Icons.access_time, color: Colors.teal),
          label: Text(
            'সময় যোগ করুন',
            style: GoogleFonts.hindSiliguri(color: Colors.teal),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.teal),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Obx(
            () => _buildDateTile(
              'শুরুর তারিখ',
              controller.startDate.value,
              () => controller.selectDate(context, true),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Obx(
            () => _buildDateTile(
              'শেষ তারিখ',
              controller.endDate.value,
              () => controller.selectDate(context, false),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTile(String label, DateTime date, VoidCallback onTap) {
    return ListTile(
      title: Text(label, style: GoogleFonts.hindSiliguri()),
      subtitle: Text(
        '${date.day}/${date.month}/${date.year}',
        style: GoogleFonts.hindSiliguri(),
      ),
      trailing: const Icon(Icons.calendar_today, color: Colors.teal),
      onTap: onTap,
      tileColor: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildDoctorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ডাক্তারের তথ্য (ঐচ্ছিক)',
          style: GoogleFonts.hindSiliguri(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildTextField(controller.doctorNameController, 'ডাক্তারের নাম'),
        const SizedBox(height: 8),
        _buildTextField(controller.doctorContactController, 'যোগাযোগ নম্বর'),
      ],
    );
  }

  Widget _buildColorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ওষুধের রঙ নির্বাচন করুন',
          style: GoogleFonts.hindSiliguri(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Wrap(
            spacing: 8,
            children: controller.medicineColors.map((color) {
              final index = controller.medicineColors.indexOf(color);
              final selected = controller.selectedColor.value == index;
              return GestureDetector(
                onTap: () => controller.selectedColor.value = index,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: color,
                  child: selected
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : null,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStockSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'স্টক তথ্য',
          style: GoogleFonts.hindSiliguri(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildNumberField(controller.currentStock, 'বর্তমান স্টক'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildNumberField(
                controller.refillThreshold,
                'রিফিল রিমাইন্ডার (সর্বনিম্ন)',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberField(RxInt value, String label) {
    final textController = TextEditingController(text: value.value.toString());
    return TextField(
      controller: textController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[100],
        labelStyle: GoogleFonts.hindSiliguri(),
      ),
      onChanged: (v) => value.value = int.tryParse(v) ?? 0,
    );
  }
}
