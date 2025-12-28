import 'package:flutter/material.dart';

class AppConstants {
  // Supabase Config
  static const String supabaseUrl = 'https://cshaxwtrvdaitgfncphg.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNzaGF4d3RydmRhaXRnZm5jcGhnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY1MDY5MzgsImV4cCI6MjA4MjA4MjkzOH0.Xrv3bfhSyV7fax1oUv8bI5IVqhamlnwqe2tgz5h3260';

  // Colors (Diambil dari CSS Vue.js / Tailwind config)
  static const Color primaryColor = Colors.black;
  static const Color accentColor = Color(0xFFEAB308); // Yellow-500
  static const Color cyanColor = Color(0xFF06B6D4); // Cyan-500
  static const Color cardBgColor = Color(0xFF1F2937); // Gray-800
}
