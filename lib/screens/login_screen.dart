import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'admin/admin_home_screen.dart'; 
import 'registration_screen.dart'; // Kayıt ekranını import et (Dosyayı oluşturduysan)

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Test kolaylığı için default değerler
  final _emailController = TextEditingController(text: "admin@pokemart.com"); 
  final _passwordController = TextEditingController(text: "123456");

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    
    FocusScope.of(context).unfocus();

    try {
      await auth.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (auth.currentUser != null && auth.currentUser!.role == 'admin') {
        // Admin ise Admin Paneline git
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
        );
      } else {
        // Normal kullanıcı ise Ana Sayfaya git
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
      
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Giriş başarısız: $error"), 
          backgroundColor: Colors.red
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthProvider>(context).isLoading;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFF0000), Color(0xFF8B0000)],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Card(
                margin: const EdgeInsets.all(24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.catching_pokemon, size: 80, color: Color(0xFFCC0000)),
                      const SizedBox(height: 16),
                      const Text(
                        "POKEMART", 
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)
                      ),
                      const SizedBox(height: 32),
                      
                      // E-POSTA ALANI
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "E-Posta",
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // ŞİFRE ALANI
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Şifre",
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // GİRİŞ BUTONU
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCC0000),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: isLoading ? null : _submit,
                          child: isLoading 
                              ? const SizedBox(
                                  height: 24, 
                                  width: 24, 
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                )
                              : const Text("GİRİŞ YAP", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Kayıt Ol butonu
                      TextButton(
                        onPressed: isLoading ? null : () {
                          // Eğer RegistrationScreen'i henüz oluşturmadıysan burayı yoruma alabilirsin
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const RegistrationScreen())
                          );
                        },
                        child: const Text(
                          "Hesabın yok mu? KAYIT OL",
                          style: TextStyle(color: Colors.white70), // Arka plan kırmızı olduğu için beyaz yazı
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}