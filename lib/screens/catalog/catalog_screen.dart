import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project_jasun/core/constants.dart';
import 'package:project_jasun/models/product_model.dart';
import 'package:project_jasun/screens/product/product_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  final int initialCategoryId;

  const CatalogScreen({
    super.key, 
    this.initialCategoryId = 0 // 0 artinya Tampilkan Semua
  });

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  late int _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategoryId;
  }

  // Ambil produk berdasarkan filter
  Future<List<Product>> _fetchProducts() async {
    // MODIFIKASI DI SINI: Tambahkan .eq('is_deleted', false)
    dynamic query = _supabase
        .from('products')
        .select()
        .eq('is_deleted', false); 
    
    // Jika kategori bukan 0 (Semua), maka filter
    if (_selectedCategoryId != 0) {
      query = query.eq('category_id', _selectedCategoryId);
    }
    
    // Urutkan terbaru
    final response = await query.order('created_at', ascending: false);
    final data = response as List<dynamic>;
    return data.map((json) => Product.fromJson(json)).toList();
}

  // Format Rupiah
  String _formatCurrency(double price) {
    return NumberFormat.currency(
      locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0
    ).format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryColor,
      // APP BAR PENTING: Agar ada tombol Back
      appBar: AppBar(
        title: const Text("Katalog Produk"),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white, // Warna ikon back putih
        elevation: 0,
      ),
      body: Column(
        children: [
          // FILTER TOMBOL (Scroll Horizontal)
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              children: [
                _buildFilterChip(0, "Semua"),
                _buildFilterChip(1, "Device"),
                _buildFilterChip(2, "Liquid"),
                _buildFilterChip(3, "Accessories"),
              ],
            ),
          ),

          // GRID PRODUK
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _fetchProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60, color: Colors.grey),
                        SizedBox(height: 16),
                        Text("Produk tidak ditemukan", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                final products = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppConstants.cardBgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.network(
                                  product.imageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_,__,___) => Container(color: Colors.grey, child: const Icon(Icons.image)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(_formatCurrency(product.price), style: const TextStyle(color: AppConstants.accentColor, fontSize: 12)),
                                ],
                              ),
                            )
                          ],
                        ),
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

  Widget _buildFilterChip(int id, String label) {
    final isSelected = _selectedCategoryId == id;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategoryId = id;
          });
        },
        selectedColor: AppConstants.accentColor,
        backgroundColor: AppConstants.cardBgColor,
        labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white),
      ),
    );
  }
}