import 'dart:convert';

class MedicineModel {
  final int? id;
  String name;
  String dosage;
  int frequency; // দৈনিক কতবার
  List<String> times; // কখন কখন (যেমন: ["08:00 AM", "08:00 PM"])
  final DateTime startDate;
  DateTime endDate;
  bool isActive;

  MedicineModel({
    this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.times,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
  });

  // ✅ সঠিক copyWith মেথড
  MedicineModel copyWith({
    int? id,
    String? name,
    String? dosage,
    int? frequency,
    List<String>? times,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      times: times ?? this.times,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
    );
  }

  // ✅ SQLite এর জন্য Map এ কনভার্ট
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'times': jsonEncode(times), // List কে JSON String এ রূপান্তর
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'isActive': isActive ? 1 : 0, // bool কে int এ রূপান্তর
    };
  }

  // ✅ Map থেকে MedicineModel তৈরি
  factory MedicineModel.fromMap(Map<String, dynamic> map) {
    return MedicineModel(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      dosage: map['dosage'] ?? '',
      frequency: map['frequency']?.toInt() ?? 0,
      times: List<String>.from(jsonDecode(map['times'] ?? '[]')),
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
      isActive: (map['isActive'] ?? 1) == 1,
    );
  }

  // ✅ ডিবাগিং এর জন্য
  @override
  String toString() {
    return 'MedicineModel(id: $id, name: $name, dosage: $dosage, frequency: $frequency, times: $times, startDate: $startDate, endDate: $endDate, isActive: $isActive)';
  }
}
