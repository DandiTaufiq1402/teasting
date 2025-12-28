import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project_jasun/core/constants.dart';
// IMPORT YANG BENAR DI BAWAH INI:
import 'package:project_jasun/screens/splash/splash_screen_1.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

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
        brightness: Brightness.dark, // Tema Gelap
        primaryColor: AppConstants.primaryColor,
        scaffoldBackgroundColor: AppConstants.primaryColor,
        useMaterial3: true,
      ),
      // Arahkan home ke SplashScreen1
      home: const SplashScreen1(), 
    );
  }
}