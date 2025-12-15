// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuth => _currentUser != null;

  // --- GİRİŞ YAP (LOGIN) ---
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!doc.exists) {
        throw Exception("Kullanıcı veritabanında bulunamadı!");
      }

      // Model dönüşümünü basitleştirdik
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      
      _currentUser = UserModel.fromMap(data, userCredential.user!.uid);

    } on FirebaseAuthException catch (e) {
      String errorMessage = "Giriş başarısız.";
      if (e.code == 'user-not-found') errorMessage = "Böyle bir kullanıcı yok.";
      if (e.code == 'wrong-password') errorMessage = "Şifre hatalı.";
      if (e.code == 'invalid-email') errorMessage = "Geçersiz e-posta formatı.";
      throw Exception(errorMessage);
    } catch (e) {
      debugPrint("GİRİŞ HATASI: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- KAYIT OL (SIGNUP) ---
  Future<void> signup(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Firestore'a yazarken userType kullandık
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'fullName': name,
        'userType': 'user', // Varsayılan kullanıcı tipi
        'address': '',
        'phoneNumber': '',
        'createdAt': FieldValue.serverTimestamp(), // İsteğe bağlı, modelde zorunlu değil
      });

      // Local state güncelleme
      _currentUser = UserModel(
        id: uid,
        email: email,
        fullName: name,
        userType: 'user',
        // address ve phoneNumber varsayılan boş gelir
      );

    } on FirebaseAuthException catch (e) {
      String errorMessage = "Kayıt başarısız.";
      if (e.code == 'email-already-in-use') errorMessage = "Bu e-posta zaten kullanımda.";
      if (e.code == 'weak-password') errorMessage = "Şifre çok zayıf (en az 6 karakter).";
      throw Exception(errorMessage);
    } catch (e) {
      debugPrint("KAYIT HATASI: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // --- ÇIKIŞ YAP (LOGOUT) ---
  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // --- PROFİL GÜNCELLE ---
  Future<void> updateUserProfile(String name, String phone, String address) async {
    final user = _currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.id).update({
        'fullName': name,
        'phoneNumber': phone,
        'address': address,
      });

      // Local state'i güncelle (Hot Reload için)
      _currentUser = UserModel(
        id: user.id,
        email: user.email,
        userType: user.userType, // userType korundu
        fullName: name,
        phoneNumber: phone,
        address: address,
      );

      notifyListeners();
    } catch (e) {
      debugPrint("Profil güncellenirken hata: $e");
      rethrow;
    }
  }
  
  // --- TÜM KULLANICILARI GETİR (Admin Panel) ---
  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserModel.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      debugPrint("Kullanıcıları getirme hatası: $e");
      return [];
    }
  }
}