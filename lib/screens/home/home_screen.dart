import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project_jasun/core/constants.dart';
import 'package:project_jasun/models/product_model.dart';
import 'package:project_jasun/services/product_service.dart';
import 'package:project_jasun/screens/catalog/catalog_screen.dart';
import 'package:project_jasun/screens/product/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();

  // Ambil nama user
  String get _userName {
    final user = Supabase.instance.client.auth.currentUser;
    return user?.userMetadata?['full_name'] ?? user?.email ?? 'Vapers';
  }

  // Format Rupiah
  String _formatCurrency(double price) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  // Navigasi ke Kategori Tertentu
  void _navigateToCategory(BuildContext context, int categoryId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CatalogScreen(initialCategoryId: categoryId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryColor,
      // AppBar custom yang lebih modern
      appBar: AppBar(
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Selamat Datang,",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              _userName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {}, // Fitur notifikasi (future)
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics:
            const BouncingScrollPhysics(), // Efek scroll membal (iOS style)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // 1. HERO BANNER (PageView)
            _buildHeroSlider(),

            const SizedBox(height: 24),

            // 2. KATEGORI (Sekarang Bisa Diklik)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                "Kategori",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildCategorySection(context),

            const SizedBox(height: 24),

            // 3. PRODUK TERBARU (Horizontal Scroll)
            _buildSectionHeader("Produk Terbaru", () {
              // Klik "Lihat Semua" -> ke Catalog
              _navigateToCategory(context, 0);
            }),
            const SizedBox(height: 12),
            _buildNewArrivals(),

            const SizedBox(height: 24),

            // 4. PROMO BANNER (Statik)
            _buildPromoBanner(),

            const SizedBox(height: 24),

            // 5. REKOMENDASI (Vertical List)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                "Rekomendasi Untukmu",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildRecommendationList(), // Mengambil sisa produk

            const SizedBox(
              height: 80,
            ), // Spacer bawah agar tidak ketutup navbar
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildHeroSlider() {
    // Simulasi Banner Slider
    return SizedBox(
      height: 180,
      child: PageView(
        controller: PageController(viewportFraction: 0.9),
        padEnds: false, // Mulai dari kiri
        children: [
          _buildBannerItem(
            color: const Color(0xFF1F2937),
            title: "Diskon 20%",
            subtitle: "Untuk Liquid Oat Drips",
            imageIcon: Icons.water_drop,
          ),
          _buildBannerItem(
            color: const Color(0xFF0F4C75),
            title: "New Device!",
            subtitle: "Centaurus M200 Ready",
            imageIcon: Icons.vape_free,
          ),
          _buildBannerItem(
            color: const Color(0xFF3282B8),
            title: "Gratis Coil",
            subtitle: "Setiap pembelian Mod",
            imageIcon: Icons.settings,
          ),
        ],
      ),
    );
  }

  Widget _buildBannerItem({
    required Color color,
    required String title,
    required String subtitle,
    required IconData imageIcon,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 12, left: 16), // Margin antar banner
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppConstants.accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Cek Sekarang",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Icon(imageIcon, size: 80, color: Colors.white.withOpacity(0.3)),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    // List Kategori Manual (Bisa juga dari DB kalau mau dinamis)
    final categories = [
      {'id': 1, 'label': 'Device', 'icon': Icons.vape_free},
      {'id': 2, 'label': 'Liquid', 'icon': Icons.water_drop},
      {'id': 3, 'label': 'Accessory', 'icon': Icons.settings},
      {'id': 0, 'label': 'Semua', 'icon': Icons.grid_view},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: categories.map((cat) {
        return GestureDetector(
          onTap: () => _navigateToCategory(context, cat['id'] as int),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppConstants.cardBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Icon(
                  cat['icon'] as IconData,
                  color: AppConstants.cyanColor,
                  size: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cat['label'] as String,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: const Text(
              "Lihat Semua",
              style: TextStyle(color: AppConstants.cyanColor, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewArrivals() {
    return FutureBuilder<List<Product>>(
      future: _productService.getProducts(), // Ambil semua data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
            height: 100,
            child: Center(
              child: Text(
                "Belum ada produk.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        final products = snapshot.data!
            .take(5)
            .toList(); // Ambil 5 produk pertama saja

        return SizedBox(
          height: 240,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(product: product),
                    ),
                  );
                },
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                    color: AppConstants.cardBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            product.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey[800],
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                      ),
                      // Info
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatCurrency(product.price),
                              style: const TextStyle(
                                color: AppConstants.accentColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.accentColor,
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: NetworkImage(
            "https://via.placeholder.com/500x150",
          ), // Bisa ganti gambar pattern/background
          fit: BoxFit.cover,
          opacity: 0.1, // Biar teks terbaca
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_shipping, size: 40, color: Colors.black),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Gratis Ongkir!",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Untuk pembelian di atas 500rb",
                  style: TextStyle(color: Colors.black87, fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text("Klaim"),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationList() {
    return FutureBuilder<List<Product>>(
      future: _productService.getProducts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        // Ambil produk, acak urutannya (shuffle), lalu ambil 10
        final products = snapshot.data!..shuffle();
        final displayProducts = products.take(6).toList();

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true, // PENTING agar bisa di dalam ScrollView
          physics:
              const NeverScrollableScrollPhysics(), // Matikan scroll listview, ikut scroll parent
          itemCount: displayProducts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final product = displayProducts[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(product: product),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppConstants.cardBgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.imageUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 70,
                          height: 70,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.stock > 0 ? "Ready Stock" : "Habis",
                            style: TextStyle(
                              color: product.stock > 0
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatCurrency(product.price),
                            style: const TextStyle(
                              color: AppConstants.accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
