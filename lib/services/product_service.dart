import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project_jasun/models/product_model.dart';

class ProductService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Ambil produk (bisa difilter kategori)
  Future<List<Product>> getProducts({int? categoryId}) async {
    try {
      // Mulai query ke tabel 'products'
      var query = _supabase.from('products').select('*');

      // Jika ada categoryId, tambahkan filter .eq
      if (categoryId != null && categoryId != 0) {
        query = query.eq('category_id', categoryId);
      }

      // Urutkan dari yang terbaru
      final response = await _supabase
        .from('products')
        .select()
        .eq('is_deleted', false) // <--- TAMBAHKAN BARIS INI
        .order('created_at', ascending: false);

      // Konversi data JSON ke List<Product>
      final data = response as List<dynamic>;
      return data.map((json) => Product.fromJson(json)).toList();
      
    } catch (e) {
      throw Exception('Gagal mengambil produk: $e');
    }
  }
}