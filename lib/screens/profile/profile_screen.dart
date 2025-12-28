import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
import 'package:project_jasun/models/order_model.dart';
import 'package:project_jasun/services/auth_service.dart';
import 'package:project_jasun/services/order_service.dart';
import 'package:project_jasun/screens/auth/login_screen.dart';
import 'package:project_jasun/core/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final OrderService _orderService = OrderService();

  // Variabel untuk menampung data user
  String _fullName = 'Loading...';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // Ambil data saat halaman dibuka
  }

  // Fungsi Ambil Data User dari Supabase Auth
  void _loadUserProfile() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() {
        // Ambil nama dari metadata (saat register), jika kosong pakai 'Pelanggan'
        _fullName = user.userMetadata?['full_name'] ?? 'Pelanggan';
        _email = user.email ?? '-';
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  String _formatCurrency(double price) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  Future<void> _handleLogout() async {
    await _authService.signOut();
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryColor,
      appBar: AppBar(
        title: const Text("Profil Saya"),
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _handleLogout,
            icon: const Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),
      body: Column(
        children: [
          // ===== HEADER PROFILE (DINAMIS) =====
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            color: AppConstants.cardBgColor,
            child: Column(
              children: [
                // Avatar dengan Inisial Nama
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppConstants.accentColor,
                  child: Text(
                    _fullName.isNotEmpty ? _fullName[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 40, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                
                // NAMA USER (Sesuai Login)
                Text(
                  _fullName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),

                // EMAIL USER
                Text(
                  _email,
                  style: const TextStyle(color: Colors.grey),
                ),
                
                const SizedBox(height: 12),

                // LABEL ROLE CUSTOMER (Pengganti NIM/Jurusan)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppConstants.cyanColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppConstants.cyanColor),
                  ),
                  child: const Text(
                    "Customer Member",
                    style: TextStyle(color: AppConstants.cyanColor, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ===== RIWAYAT PESANAN =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Riwayat Pesanan",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: FutureBuilder<List<Order>>(
              future: _orderService.getMyOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)),
                  );
                }

                final orders = snapshot.data ?? [];

                if (orders.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_bag_outlined, size: 60, color: Colors.grey),
                        SizedBox(height: 12),
                        Text("Belum ada riwayat pesanan", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppConstants.cardBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Order #${order.id}",
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppConstants.cyanColor),
                              ),
                              _buildStatusBadge(order.status),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatDate(order.createdAt),
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const Divider(color: Colors.white12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total Belanja", style: TextStyle(color: Colors.white)),
                              Text(
                                _formatCurrency(order.total),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.accentColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'completed':
        color = Colors.green;
        break;
      case 'shipped':
        color = Colors.blue;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2), // Menggunakan withValues agar future-proof
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}