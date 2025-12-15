import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../providers/auth_provider.dart';

class FavoritesProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthProvider _authProvider;

  Set<String> _favoriteProductIds = {}; 

  FavoritesProvider(this._authProvider) {
    _authProvider.addListener(_fetchFavorites);
    if (_authProvider.isAuth) {
      _fetchFavorites();
    }
  }

  Set<String> get favoriteProductIds => _favoriteProductIds;

  bool isFavorite(String productId) {
    return _favoriteProductIds.contains(productId);
  }

  Future<void> _fetchFavorites() async {
    final userId = _authProvider.currentUser?.id;
    if (userId == null) {
      _favoriteProductIds.clear();
      notifyListeners();
      return;
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .get();
      
      _favoriteProductIds = snapshot.docs.map((doc) => doc.id).toSet();
      notifyListeners();

    } catch (e) {
      debugPrint("Favoriler çekilirken hata: $e");
    }
  }

 
  Future<void> toggleFavoriteStatus(Product product) async {
    final userId = _authProvider.currentUser?.id;
    if (userId == null) return;

    final productId = product.id;
    final docRef = _firestore.collection('users').doc(userId).collection('favorites').doc(productId);

    if (_favoriteProductIds.contains(productId)) {
      await docRef.delete();
      _favoriteProductIds.remove(productId);
    } else {
      await docRef.set({
        'name': product.name,
        'addedAt': FieldValue.serverTimestamp(),
      });
      _favoriteProductIds.add(productId);
    }
    
    notifyListeners();
  }
}