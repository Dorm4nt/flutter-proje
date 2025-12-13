// lib/models/product.dart
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final int stock; // Stok takibi gereksinimi
  final String description;
  final String imageUrl;
  final double rating; // Ortalama puan (Opsiyonel özelliklerden)
  final bool isFeatured; // Kampanyalı ürünler için

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.description,
    required this.imageUrl,
    this.rating = 0.0,
    this.isFeatured = false,
  });

  // Firebase'den veri çekerken işine yarayacak
  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      category: map['category'] ?? 'Genel',
      price: (map['price'] ?? 0).toDouble(),
      stock: map['stock'] ?? 0,
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      isFeatured: map['isFeatured'] ?? false,
    );
  }

  // Firebase'e veri gönderirken işine yarayacak
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'stock': stock,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'isFeatured': isFeatured,
    };
  }
}