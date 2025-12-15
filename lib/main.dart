// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// Kendi dosyaların
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/favorites_provider.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCWVvqF8vlT2xylTC5nHKJ-cBMNfwSiI_o",
      authDomain: "pokemonshop-97cde.firebaseapp.com",
      projectId: "pokemonshop-97cde",
      storageBucket: "pokemonshop-97cde.firebasestorage.app",
      messagingSenderId: "883655907284",
      appId: "1:883655907284:web:2ef662c8af0d1d1cc62841",
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        
        // DÜZELTİLDİ: ProxyProvider kullanımı
        ChangeNotifierProxyProvider<AuthProvider, FavoritesProvider>(
          create: (ctx) => FavoritesProvider(
            Provider.of<AuthProvider>(ctx, listen: false),
          ),
          update: (ctx, auth, previousFavs) => FavoritesProvider(auth),
        ),
      ],
      child: const PokeMartApp(),
    ),
  );
}

class PokeMartApp extends StatelessWidget {
  const PokeMartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokeMart V2',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const LoginScreen(),
    );
  }
}