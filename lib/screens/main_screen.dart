import 'package:flutter/material.dart';
import 'package:project_jasun/core/constants.dart';
import 'package:project_jasun/screens/home/home_screen.dart'; // Kita buat setelah ini
import 'package:project_jasun/screens/catalog/catalog_screen.dart'; // Sesuaikan nama project
import 'package:project_jasun/screens/cart/cart_screen.dart';
import 'package:project_jasun/screens/profile/profile_screen.dart';
import 'package:project_jasun/screens/team/team_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Daftar Halaman (Sementara kita pakai Placeholder untuk Catalog, Cart, Profile)
  final List<Widget> _pages = [
    const HomeScreen(),
    const CatalogScreen(),
    const CartScreen(),
    const ProfileScreen(), // <--- GANTI INI
    const TeamScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryColor,
      body:
          _pages[_selectedIndex], // Menampilkan halaman sesuai icon yang dipilih
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppConstants.cardBgColor,
        selectedItemColor: AppConstants.accentColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // Agar ikon tidak bergeser
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Catalog'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups), // Ikon Kelompok
            label: 'Team',
          ),
        ],
      ),
    );
  }
}
