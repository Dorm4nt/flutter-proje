// lib/widgets/main_drawer.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';

class MainDrawer extends StatelessWidget {
  final String username;
  const MainDrawer({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    // KOD DÜZELTİLDİ: Provider'ı yerel değişkene atadık.
    final auth = Provider.of<AuthProvider>(context, listen: false); 

    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: const Color(0xFFCC0000),
            child: Text(
              'Merhaba, $username!',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 26,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildListTile(Icons.home_outlined, 'Ana Sayfa', () {
            Navigator.of(context).pop();
          }),
          _buildListTile(Icons.favorite_border, 'Favorilerim', () {
            Navigator.of(context).pop();
          }),
          _buildListTile(Icons.receipt_long, 'Siparişlerim', () {
            Navigator.of(context).pop();
          }),
          const Divider(),
          _buildListTile(Icons.exit_to_app, 'Çıkış Yap', () {
            Navigator.of(context).pop(); 
            auth.logout(); 
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginScreen())
            );
          }),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback tapHandler) {
    return ListTile(
      leading: Icon(icon, size: 26),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }
}