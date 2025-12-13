import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  // Başlangıçta liste boş. Firebase'den veri çekince dolacak.
  // Admin panelinden manuel ürün ekleyerek test edebilirsin.
  final List<Product> _items = [];

  final List<String> _favoriteIds = [];
  
  // İŞTE BURASI: Seçili kategoriyi tutan değişken
  String _selectedCategory = "Tümü";
  
  String _searchQuery = "";

  // --- GETTER'LAR (Dışarıdan okumak için) ---
  
  // 1. Seçili kategoriyi dışarıya açıyoruz (Home Screen'de hata veren yer burasıydı)
  String get selectedCategory => _selectedCategory;

  // 2. Filtrelenmiş ürün listesi
  List<Product> get items {
    // Kategori Filtresi
    List<Product> filtered = _selectedCategory == "Tümü" 
        ? [..._items] 
        : _items.where((p) => p.category == _selectedCategory).toList();
    
    // Arama Filtresi
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    
    return filtered;
  }

  // 3. Favori ürünleri getir
  List<Product> get favoriteItems {
    return _items.where((p) => _favoriteIds.contains(p.id)).toList();
  }

  // --- SETTER'LAR ve İŞLEMLER ---

  // Kategoriyi değiştir (Bunu Home Screen'deki butonlar çağıracak)
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners(); // Ekranı güncelle
  }

  // Arama yap
  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Favori ekle/çıkar
  void toggleFavorite(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }

  // Favori kontrolü
  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }

  // --- ADMIN İŞLEMLERİ (CRUD) ---

  // Yeni Ürün Ekle
  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  // Ürün Güncelle
  void updateProduct(String id, Product newProduct) {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      _items[index] = newProduct;
      notifyListeners();
    }
  }

  // Ürün Sil
  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}