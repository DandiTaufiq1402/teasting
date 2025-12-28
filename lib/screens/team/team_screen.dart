import 'package:flutter/material.dart';
import 'package:project_jasun/core/constants.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Kelompok
    final List<Map<String, String>> members = [
      {'name': 'Beryl Rafly Agatha', 'nim': '1123150088'},
      {'name': 'Dandi Taufiqurrahman', 'nim': '1123150054'},
      {
        'name': 'Dzikri Abdurrahman Haris',
        'nim': '1123150049',
      }, // NIM disesuaikan
      {'name': 'Evan Alfeus Hendrik', 'nim': '1123150186'},
      {'name': 'Vibra Ayu Kharisma', 'nim': '1123150115'},
    ];

    return Scaffold(
      backgroundColor: AppConstants.primaryColor,
      appBar: AppBar(
        title: const Text("Data Kelompok"),
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false, // Hilangkan tombol back
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- HEADER JURUSAN ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppConstants.accentColor, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(Icons.school, size: 50, color: Colors.black),
                  SizedBox(height: 10),
                  Text(
                    "TEKNIK INFORMATIKA",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Konsentrasi: Software Engineer 1",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Anggota Tim",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // --- LIST ANGGOTA ---
            ...members.map(
              (member) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppConstants.cardBgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppConstants.accentColor.withOpacity(0.2),
                    child: Text(
                      member['name']![0], // Ambil huruf depan nama
                      style: const TextStyle(
                        color: AppConstants.accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    member['name']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "NIM: ${member['nim']}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
