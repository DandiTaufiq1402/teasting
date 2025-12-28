import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project_jasun/core/constants.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryColor,
      body: FutureBuilder(
        future: Supabase.instance.client.from('users').select().order('created_at'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final users = snapshot.data as List;

          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: users.length,
            separatorBuilder: (_,__) => const Divider(color: Colors.grey),
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppConstants.accentColor,
                  child: Text(user['full_name']?[0] ?? 'U', style: const TextStyle(color: Colors.black)),
                ),
                title: Text(user['full_name'] ?? 'No Name', style: const TextStyle(color: Colors.white)),
                subtitle: Text("${user['email']}\nRole: ${user['role']}", style: const TextStyle(color: Colors.grey)),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}