// lib/providers/cart_provider.dart
import 'package:flutter/material.dart';
import '../models/pokemon_figure.dart';
import '../data/dummy_products.dart';

class CartItem {
  final PokemonFigure product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  final List<PokemonFigure> _allProducts = dummyProducts;

  List<CartItem> get cartItems => List.unmodifiable(_items);
  List<PokemonFigure> get allProducts => List.unmodifiable(_allProducts);

  List<PokemonFigure> getProductsByCategory(String category) {
    if (category == "Tümü") return _allProducts;
    return _allProducts.where((p) => p.category == category).toList();
  }

  double get totalPrice => _items.fold(0.0, (sum, it) => sum + it.product.price * it.quantity);

  void addToCart(PokemonFigure product) {
    final idx = _items.indexWhere((c) => c.product.id == product.id);
    if (idx == -1) {
      _items.add(CartItem(product: product, quantity: 1));
    } else {
      _items[idx].quantity += 1;
    }
    notifyListeners();
  }

  void decreaseFromCart(PokemonFigure product) {
    final idx = _items.indexWhere((c) => c.product.id == product.id);
    if (idx != -1) {
      if (_items[idx].quantity > 1) {
        _items[idx].quantity -= 1;
      } else {
        _items.removeAt(idx);
      }
      notifyListeners();
    }
  }

  void removeFromCart(PokemonFigure product) {
    _items.removeWhere((c) => c.product.id == product.id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void toggleFavorite(int id) {
    final index = _allProducts.indexWhere((p) => p.id == id);
    if (index != -1) {
      _allProducts[index].isFavorite = !_allProducts[index].isFavorite;
      notifyListeners();
    }
  }
}
