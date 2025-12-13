import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';

import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Tüm "beyin" takımını buraya kaydediyoruz
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
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
      // Başlangıç ekranı LoginScreen
      home: const LoginScreen(),
    );
  }
}