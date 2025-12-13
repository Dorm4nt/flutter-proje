// lib/screens/registration_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _name = '';

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    
    // Klavyeyi kapat
    FocusScope.of(context).unfocus();

    final auth = Provider.of<AuthProvider>(context, listen: false);

    try {
      await auth.signup(_email.trim(), _password.trim(), _name.trim());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kayıt başarılı! Giriş yapılıyor...")));
      
      // Kayıt başarılı, ana sayfaya yönlendir
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kayıt başarısız: $error"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthProvider>(context).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text("Hesap Oluştur")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_add_alt_1, size: 70, color: Colors.blue),
                const SizedBox(height: 30),

                // İsim
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Ad Soyad'),
                  validator: (val) => val!.isEmpty ? 'İsim gerekli' : null,
                  onSaved: (val) => _name = val!,
                ),
                const SizedBox(height: 16),
                
                // E-posta
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Posta'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => !val!.contains('@') ? 'Geçerli e-posta gir' : null,
                  onSaved: (val) => _email = val!,
                ),
                const SizedBox(height: 16),
                
                // Şifre
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Şifre (Min 6 karakter)'),
                  obscureText: true,
                  validator: (val) => val!.length < 6 ? 'Şifre çok kısa' : null,
                  onSaved: (val) => _password = val!,
                ),
                const SizedBox(height: 30),
                
                // Buton
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("KAYIT OL"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}