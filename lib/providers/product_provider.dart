import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore importu
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _items = [];
  final List<String> _favoriteIds = [];
  
  String _selectedCategory = "Tümü";
  String _searchQuery = "";

  // GETTER'LAR
  String get selectedCategory => _selectedCategory;

  List<Product> get items {
    List<Product> filtered = _selectedCategory == "Tümü" 
        ? [..._items] 
        : _items.where((p) => p.category == _selectedCategory).toList();
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return filtered;
  }

  List<Product> get favoriteItems {
    return _items.where((p) => _favoriteIds.contains(p.id)).toList();
  }

  // --- FIRESTORE İŞLEMLERİ ---

  // 1. Ürünleri Çek (Fetch)
  Future<void> fetchProducts() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('products').get();
      final List<Product> loadedProducts = [];
      
      for (var doc in snapshot.docs) {
        loadedProducts.add(Product.fromMap(doc.data(), doc.id));
      }
      
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      debugPrint("Ürünler çekilemedi: $e");
    }
  }

  // 2. Ürün Ekle (Add)
  Future<void> addProduct(Product product) async {
    try {
      final docRef = await FirebaseFirestore.instance.collection('products').add(product.toMap());
      
      final newProduct = Product(
        id: docRef.id,
        name: product.name,
        category: product.category,
        price: product.price,
        stock: product.stock,
        description: product.description,
        imageUrl: product.imageUrl,
      );
      
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      debugPrint("Ekleme hatası: $e");
      rethrow;
    }
  }

  // 3. Ürün Güncelle (Update)
  Future<void> updateProduct(String id, Product newProduct) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      try {
        await FirebaseFirestore.instance.collection('products').doc(id).update(newProduct.toMap());
        _items[index] = newProduct;
        notifyListeners();
      } catch (e) {
        debugPrint("Güncelleme hatası: $e");
        rethrow;
      }
    }
  }

  // 4. Ürün Sil (Delete)
  Future<void> deleteProduct(String id) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(id).delete();
      _items.removeWhere((prod) => prod.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint("Silme hatası: $e");
      rethrow;
    }
  }

  // --- DİĞER FONKSİYONLAR ---

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleFavorite(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }

  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }
}