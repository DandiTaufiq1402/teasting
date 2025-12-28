import 'package:flutter/material.dart';
import 'package:project_jasun/services/cart_service.dart';
import 'package:project_jasun/core/constants.dart';
import 'package:project_jasun/screens/main_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPayment = 'Transfer Bank';
  final List<String> _methods = ['Transfer Bank', 'E-Wallet', 'COD (Bayar di Tempat)'];
  bool _isLoading = false;

  Future<void> _processOrder() async {
    setState(() => _isLoading = true);
    
    try {
      // Panggil fungsi checkout di CartService
      await CartService().checkout(); 
      
      if (!mounted) return;

      // Tampilkan Dialog Sukses
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppConstants.cardBgColor,
          title: const Text("Pesanan Berhasil!", style: TextStyle(color: Colors.white)),
          content: const Text("Terima kasih sudah berbelanja. Cek status pesanan di Profil.", style: TextStyle(color: Colors.grey)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                  (route) => false,
                );
              },
              child: const Text("OK", style: TextStyle(color: AppConstants.accentColor)),
            )
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryColor,
      appBar: AppBar(
        title: const Text("Ringkasan & Pembayaran"), 
        backgroundColor: AppConstants.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const Text("Pilih Metode Pembayaran", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
             const SizedBox(height: 16),
             ..._methods.map((method) => Container(
               margin: const EdgeInsets.only(bottom: 8),
               decoration: BoxDecoration(
                 color: AppConstants.cardBgColor,
                 borderRadius: BorderRadius.circular(8)
               ),
               child: RadioListTile<String>(
                 title: Text(method, style: const TextStyle(color: Colors.white)),
                 value: method,
                 groupValue: _selectedPayment,
                 activeColor: AppConstants.accentColor,
                 onChanged: (val) => setState(() => _selectedPayment = val!),
               ),
             )),
             
             const Spacer(),
             
             ElevatedButton(
               onPressed: _isLoading ? null : _processOrder,
               style: ElevatedButton.styleFrom(
                 backgroundColor: AppConstants.accentColor, 
                 minimumSize: const Size(double.infinity, 50),
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
               ),
               child: _isLoading 
                 ? const CircularProgressIndicator(color: Colors.black) 
                 : const Text("BUAT PESANAN", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
             )
          ],
        ),
      ),
    );
  }
}