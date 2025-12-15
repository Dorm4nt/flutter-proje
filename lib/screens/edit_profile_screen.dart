import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form verilerini tutacak değişkenler
  late String _name;
  late String _phone;
  late String _address;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Mevcut bilgileri formun içine doldur
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (user != null) {
      _name = user.fullName;
      _phone = user.phoneNumber;
      _address = user.address;
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .updateUserProfile(_name, _phone, _address);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil başarıyla güncellendi! ✅')),
      );
      Navigator.of(context).pop(); // Sayfayı kapat
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bir hata oluştu!')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profili Düzenle"),
        backgroundColor: const Color(0xFFCC0000),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // AD SOYAD
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Ad Soyad', border: OutlineInputBorder()),
                textInputAction: TextInputAction.next,
                validator: (value) => value!.isEmpty ? 'Ad soyad boş olamaz' : null,
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 16),
              
              // TELEFON
              TextFormField(
                initialValue: _phone,
                decoration: const InputDecoration(labelText: 'Telefon Numarası', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                onSaved: (value) => _phone = value ?? '',
              ),
              const SizedBox(height: 16),
              
              // ADRES
              TextFormField(
                initialValue: _address,
                decoration: const InputDecoration(labelText: 'Açık Adres', border: OutlineInputBorder()),
                keyboardType: TextInputType.streetAddress,
                maxLines: 3,
                onSaved: (value) => _address = value ?? '',
              ),
              const SizedBox(height: 24),

              // KAYDET BUTONU
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _saveForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCC0000),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("DEĞİŞİKLİKLERİ KAYDET", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}