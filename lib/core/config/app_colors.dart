import 'package:flutter/material.dart';

class AppColors {
  // একটি সিড কালার যা থেকে সম্পূর্ণ থিম জেনারেট হবে
  static const Color seedColor = Color(0xFF00796B); // Teal

  // মূল রঙগুলো (ঐচ্ছিক, কিন্তু সরাসরি ব্যবহারের জন্য রাখা যেতে পারে)
  static const Color primary = seedColor;
  static const Color onPrimary = Colors.white;
  static const Color secondary = Color(0xFF4DB6AC);
  static const Color onSecondary = Colors.white;
  static const Color error = Colors.red;
  static const Color onError = Colors.white;
}
