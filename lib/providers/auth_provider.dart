// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuth => _currentUser != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 1500)); // Simülasyon

      if (email == 'admin@pokemart.com' && password == '123456') {
        _currentUser = UserModel(
          id: 'admin_1',
          email: email,
          fullName: 'Poke Admin',
          role: 'admin',
          createdAt: DateTime.now(),
        );
      } else if (email == 'user@pokemart.com' && password == '123456') {
        _currentUser = UserModel(
          id: 'user_1',
          email: email,
          fullName: 'Eğitmen Ash',
          role: 'user',
          createdAt: DateTime.now(),
          address: 'Pallet Kasabası, Kanto Bölgesi',
        );
      } else {
        throw Exception("E-Posta veya Şifre hatalı.");
      }

    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signup(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 1500)); // Simülasyon
      
      _currentUser = UserModel(
        id: DateTime.now().toString(),
        email: email,
        fullName: name,
        role: 'user',
        createdAt: DateTime.now(),
      );

    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateProfile({
    String? fullName, 
    String? phoneNumber, 
    String? address
  }) async {
    if (_currentUser == null) {
      throw Exception("Kullanıcı bulunamadı. Lütfen önce giriş yapın.");
    }

    _currentUser = UserModel(
      id: _currentUser!.id,
      email: _currentUser!.email,
      fullName: fullName ?? _currentUser!.fullName,
      phoneNumber: phoneNumber ?? _currentUser!.phoneNumber,
      address: address ?? _currentUser!.address,
      role: _currentUser!.role,
      createdAt: _currentUser!.createdAt,
    );

    notifyListeners();
  }
  
  List<UserModel> getAllUsers() {
    return [
      UserModel(id: 'u1', email: 'user@test.com', fullName: 'Ash Ketchum', role: 'user', createdAt: DateTime.now()),
      UserModel(id: 'u2', email: 'brock@test.com', fullName: 'Brock Gym Leader', role: 'user', createdAt: DateTime.now()),
    ];
  }
}