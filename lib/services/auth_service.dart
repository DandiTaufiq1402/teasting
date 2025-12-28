import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Login
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Register (BARU DITAMBAHKAN)
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
      }, // Data ini akan masuk ke trigger SQL public.users
    );
  }

  Future<String> getUserRole() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return 'customer';

    try {
      final data = await _supabase
          .from('users')
          .select('role')
          .eq('id', user.id)
          .single();
      
      return data['role'] as String? ?? 'customer';
    } catch (e) {
      return 'customer'; 
    }
  
  }

  // Logout
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? get currentUser => _supabase.auth.currentUser;
  Session? get currentSession => _supabase.auth.currentSession;
}
