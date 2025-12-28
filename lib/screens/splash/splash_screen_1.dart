import 'dart:async';
import 'package:flutter/material.dart'; // Sesuaikan jika path beda
import 'package:project_jasun/screens/splash/splash_screen_2.dart'; // Import Splash 2

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({super.key});

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  @override
  void initState() {
    super.initState();
    // Timer 3 detik, lalu pindah ke Splash 2
    Timer(const Duration(seconds: 3), () {
      // Gunakan pushReplacement agar user tidak bisa kembali ke layar ini
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen2()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Latar belakang putih bersih agar logo terlihat jelas
      backgroundColor: Colors.white, 
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Image.asset(
            'assets/images/logo_kampus.png', // Pastikan nama file sesuai
            width: 200, // Atur ukuran logo
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}