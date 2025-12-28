class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String imageUrl;
  final int categoryId;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.categoryId,
  });

  // Fungsi untuk mengubah JSON dari Supabase menjadi Object Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] ?? 'Tanpa Nama',
      description: json['description'] ?? '',
      // Supabase kadang mengembalikan angka sebagai int/double, kita paksa jadi double
      price: (json['price'] as num).toDouble(), 
      stock: json['stock'] as int,
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/150', // Placeholder jika gambar kosong
      categoryId: json['category_id'] as int,
    );
  }
}