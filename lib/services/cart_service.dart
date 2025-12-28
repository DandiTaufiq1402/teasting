import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project_jasun/models/cart_item_model.dart';
import 'package:project_jasun/models/product_model.dart';

class CartService {
  // Singleton Pattern
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  // List penyimpan data sementara
  // PERHATIKAN: Nama variabelnya adalah '_items'
  final List<CartItem> _items = [];

  List<CartItem> get items => _items; 

  // Tambah ke Cart (Standard)
  void addToCart(Product product, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
  }

  void updateQuantity(Product product, int delta) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _items[index].quantity += delta;
      
      // Hapus jika quantity 0 atau negatif
      if (_items[index].quantity <= 0) {
        removeItem(product.id);
      }
    }
  }

  // --- BAGIAN YANG DIPERBAIKI ---
  // Hapus item berdasarkan ID Product
  void removeItem(int id) {
    // FIX 1: Gunakan '_items', bukan '_cartItems'
    // FIX 2: Gunakan 'item.product.id' agar sesuai dengan logic addToCart
    _items.removeWhere((item) => item.product.id == id);
  }
  // -----------------------------

  // Hitung Total Belanja
  double getTotalPrice() {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  // Kosongkan Cart
  void clearCart() {
    _items.clear();
  }

  // Checkout ke Supabase
  Future<void> checkout() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) throw Exception("User tidak terdeteksi");
    if (_items.isEmpty) throw Exception("Keranjang kosong");

    // 1. Buat Order
    final orderResponse = await supabase.from('orders').insert({
      'user_id': user.id,
      'total': getTotalPrice(),
      'status': 'pending', 
      'created_at': DateTime.now().toIso8601String(),
    }).select().single();

    final orderId = orderResponse['id'];

    // 2. Masukkan Item Order
    final List<Map<String, dynamic>> orderItemsData = _items.map((item) {
      return {
        'order_id': orderId,
        'product_id': item.product.id,
        'quantity': item.quantity,
        'price': item.product.price,
      };
    }).toList();

    await supabase.from('order_items').insert(orderItemsData);

    // 3. Bersihkan Cart Lokal
    clearCart();
  }
}