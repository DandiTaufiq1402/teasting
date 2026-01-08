import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_jasun/core/constants.dart';
import 'package:project_jasun/screens/splash/splash_screen_1.dart';
import 'package:project_jasun/services/notification_service.dart';

void main() async {
  // 1. Bindings harus baris pertama
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 2. Coba Inisialisasi Firebase
    // Pastikan file android/app/google-services.json sudah ada!
    await Firebase.initializeApp();
    print("✅ Firebase berhasil diinisialisasi");

    // 3. Coba Inisialisasi Notification Service
    // Jika file ini error, cek apakah class NotificationService sudah dibuat dengan benar
    await NotificationService().initialize();
    print("✅ Notification Service berhasil diinisialisasi");
  } catch (e) {
    // Jika error, cetak di konsol agar ketahuan
    print("❌ ERROR INIT FIREBASE/NOTIF: $e");
  }

  try {
    // 4. Inisialisasi Supabase
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
    print("✅ Supabase berhasil diinisialisasi");
  } catch (e) {
    print("❌ ERROR INIT SUPABASE: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vape Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppConstants.primaryColor,
        scaffoldBackgroundColor: AppConstants.primaryColor,
        useMaterial3: true,
      ),
      home: const SplashScreen1(),
    );
  }
}
