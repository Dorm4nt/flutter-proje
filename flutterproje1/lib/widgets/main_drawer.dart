// lib/widgets/main_drawer.dart
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

class MainDrawer extends StatelessWidget {
  final String username;
  const MainDrawer({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        UserAccountsDrawerHeader(
          accountName: Text(username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          accountEmail: const Text("Poke-Eğitmen | Seviye 12"),
          currentAccountPicture: CircleAvatar(backgroundColor: Colors.white, child: Text(username[0].toUpperCase(), style: const TextStyle(fontSize: 30, color: Colors.red, fontWeight: FontWeight.bold))),
          decoration: const BoxDecoration(
            image: DecorationImage(image: NetworkImage("https://img.freepik.com/free-vector/red-halftone-background_1409-983.jpg"), fit: BoxFit.cover, opacity: 0.8),
          ),
        ),
        ListTile(leading: const Icon(Icons.home), title: const Text('Ana Sayfa'), onTap: () => Navigator.pop(context)),
        ListTile(leading: const Icon(Icons.favorite), title: const Text('Favorilerim'), onTap: () {}),
        ListTile(leading: const Icon(Icons.history), title: const Text('Sipariş Geçmişi'), onTap: () {}),
        const Divider(),
        ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text('Çıkış Yap', style: TextStyle(color: Colors.red)), onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()))),
      ]),
    );
  }
}
