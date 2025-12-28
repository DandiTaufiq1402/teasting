import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project_jasun/core/constants.dart';
// Dua import ini WAJIB ada dan DIPAKAI di bawah:
import 'package:project_jasun/screens/auth/login_screen.dart';
import 'package:project_jasun/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    // 1. Delay 2 detik
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // 2. Cek apakah ada user yang sedang login
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      // ADA USER -> Masuk ke MainScreen (Home)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainScreen())
      );
    } else {
      // TIDAK ADA USER -> Masuk ke LoginScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_circle, size: 100, color: AppConstants.accentColor),
            const SizedBox(height: 20),
            Text(
              "VAPE VIOLENCE",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(color: AppConstants.cyanColor),
          ],
        ),
      ),
    );
  }
}