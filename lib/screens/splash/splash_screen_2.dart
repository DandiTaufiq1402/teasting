import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_jasun/core/constants.dart';
import 'package:project_jasun/screens/auth/login_screen.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key});

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Opsional: Tetap ada timer otomatis 5 detik, atau matikan jika ingin manual klik tombol
    _timer = Timer(const Duration(seconds: 30), () {
      _navigateToLogin();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Matikan timer jika user pindah halaman sebelum waktu habis
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryColor, // Background App
      body: Center(
        child: Container(
          width: 300, // Sesuai CSS width: 300px
          // height: 450, // Bisa auto height atau fixed
          decoration: BoxDecoration(
            color: Colors.white, // --bg-color: #fff
            borderRadius: BorderRadius.circular(20), // border-radius: 20px
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- 1. CARD IMG (HEADER) ---
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Container(
                      height: 150, // height: 192px (disesuaikan sedikit)
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        // Kita buat gradient mirip SVG di CSS
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFC726E), // Warna merah muda dari CSS
                            Color(0xFFFFC3A0),
                          ],
                        ),
                      ),
                      // Opsional: Tambah Pattern overlay jika mau (pake Image.asset transparan)
                      child: const Icon(Icons.school, size: 80, color: Colors.white24), 
                    ),
                  ),

                  // --- SPACING UNTUK AVATAR ---
                  const SizedBox(height: 60), // Memberi ruang karena avatar menumpuk

                  // --- 2. TEXT CONTENT ---
                  const Text(
                    "Dandi Taufiqurrahman", // --main-color
                    style: TextStyle(
                      fontFamily: 'Roboto', // System UI
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Subtitle: NIM & Jurusan
                  const Text(
                    "NIM: 1123150054",
                    style: TextStyle(fontSize: 14, color: Color(0xFF78858F)),
                  ),
                  const Text(
                    "Software Engineer-1 ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Color(0xFF78858F)),
                  ),
                  const Text(
                    "Flutter - Admin Dashboard",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Color(0xFF78858F)),
                  ),

                  const SizedBox(height: 24),

                  // --- 3. BUTTONS ---
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Tombol 1: Outlined (Info)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.black, width: 2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text("INFO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                        
                        const SizedBox(width: 12),

                        // Tombol 2: Solid (Lanjut Login)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _navigateToLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black, // --main-color
                              foregroundColor: Colors.white, // --bg-color
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              elevation: 0,
                            ),
                            child: const Text("MASUK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // --- 4. AVATAR (FLOATING) ---
              Positioned(
                top: 90, // Posisi agar setengah di header, setengah di body
                child: Container(
                  width: 114,
                  height: 114,
                  decoration: BoxDecoration(
                    color: Colors.white, // Border putih tebal
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(6), // Padding untuk border putih
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/foto_mahasiswa.jpg'),
                    backgroundColor: Colors.grey, // Placeholder warna jika foto gagal
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}