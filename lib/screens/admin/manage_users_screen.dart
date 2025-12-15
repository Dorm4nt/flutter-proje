// lib/screens/admin/manage_users_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart'; 

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kullanıcı Yönetimi")),
      body: FutureBuilder<List<UserModel>>(
        future: Provider.of<AuthProvider>(context, listen: false).getAllUsers(),
        builder: (ctx, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Hata oluştu: ${snapshot.error}"));
          }

          final users = snapshot.data;
          if (users == null || users.isEmpty) {
            return const Center(child: Text("Kayıtlı kullanıcı bulunamadı."));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (ctx, i) {
              final user = users[i];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(user.fullName),
                subtitle: Text(user.email),
                // DÜZELTİLDİ: role yerine userType kullanıldı
                trailing: Text(user.userType.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${user.fullName} Detay Sayfası"),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}