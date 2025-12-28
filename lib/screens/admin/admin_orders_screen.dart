import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project_jasun/core/constants.dart';
import 'package:intl/intl.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override 
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final _supabase = Supabase.instance.client;

  Future<void> _updateStatus(int orderId, String newStatus) async {
    await _supabase.from('orders').update({'status': newStatus}).eq('id', orderId);
    setState(() {}); 
  }

  Color _getStatusColor(String status) {
    switch(status) {
      case 'completed': return Colors.green;
      case 'shipped': return Colors.blue;
      case 'cancelled': return Colors.red;
      default: return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryColor,
      body: FutureBuilder(
        future: _supabase.from('orders').select('*, users(full_name)').order('created_at', ascending: false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData) return const Center(child: Text("Belum ada order", style: TextStyle(color: Colors.grey)));
          
          final orders = snapshot.data as List;
          
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final user = order['users'] != null ? order['users']['full_name'] : 'Unknown User';
              final status = order['status'];
              final total = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(order['total']);

              return Card(
                color: AppConstants.cardBgColor,
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  iconColor: Colors.white,
                  collapsedIconColor: Colors.grey,
                  title: Text("Order #${order['id']} - $user", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(total, style: const TextStyle(color: AppConstants.accentColor)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor(status).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: _getStatusColor(status))
                          ),
                          child: Text(status.toUpperCase(), style: TextStyle(color: _getStatusColor(status), fontSize: 10, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.black12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Ubah Status:", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _statusBtn(order['id'], 'pending', Colors.orange),
                              _statusBtn(order['id'], 'shipped', Colors.blue),
                              _statusBtn(order['id'], 'completed', Colors.green),
                              _statusBtn(order['id'], 'cancelled', Colors.red),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _statusBtn(int id, String status, Color color) {
    return InkWell(
      onTap: () => _updateStatus(id, status),
      child: Column(
        children: [
          Icon(Icons.circle, color: color, size: 20),
          const SizedBox(height: 4),
          Text(status, style: TextStyle(color: color, fontSize: 10))
        ],
      ),
    );
  }
}