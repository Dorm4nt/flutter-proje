// lib/screens/admin/manage_users_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Admin yetkisi gerektirdiği için AuthProvider kullanıyoruz.
    final users = Provider.of<AuthProvider>(context).getAllUsers();

    return Scaffold(
      appBar: AppBar(title: const Text("Kullanıcı Yönetimi")),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (ctx, i) => ListTile(
          leading: const Icon(Icons.person),
          title: Text(users[i].fullName),
          subtitle: Text(users[i].email),
          trailing: Text(users[i].role.toUpperCase()),
          onTap: () {
            // Kullanıcı Detay sayfasına git (isteğe bağlı)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${users[i].fullName} Detay Sayfası"), duration: const Duration(seconds: 1))
            );
          },
        ),
      ),
    );
  }
}