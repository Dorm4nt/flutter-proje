import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/orders_screen.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart'; 
import '../screens/edit_profile_screen.dart'; // ✅ YENİ EKLENDİ: Profil düzenleme ekranı

class MainDrawer extends StatelessWidget {
  final String username;

  const MainDrawer({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Üst Kısım (Header)
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFFCC0000), // Pokemon kırmızısı
            ),
            accountName: Text(
              username,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: const Text("PokeMart Üyesi"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Color(0xFFCC0000)),
            ),
          ),
          
          // Menü Linkleri
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Ana Sayfa'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
          ),
          const Divider(),

          // ✅ YENİ EKLENDİ: PROFİL/ADRES DÜZENLEME BUTONU
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profilim / Adres'),
            onTap: () {
              Navigator.of(context).pop(); // Menüyü kapat
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Siparişlerim'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          const Divider(),
          
          const Spacer(), 
          
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Çıkış Yap', style: TextStyle(color: Colors.red)),
            onTap: () {
              // Dialog kapat
              Navigator.of(context).pop(); 
              // Çıkış yap ve Login ekranına at
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}