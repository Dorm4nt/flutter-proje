import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import 'edit_product_screen.dart';

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ürün Yönetimi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProductScreen())),
          ),
        ],
      ),
      // KRİTİK DOKUNUŞ: Sayfa açılınca verileri çekmesi için FutureBuilder ekledik
      body: FutureBuilder(
        future: Provider.of<ProductProvider>(context, listen: false).fetchProducts(),
        builder: (ctx, snapshot) {
          
          // 1. Durum: Yükleniyor
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Durum: Hata
          if (snapshot.error != null) {
            return const Center(child: Text('Bir hata oluştu!'));
          }

          // 3. Durum: Yüklendi, Listeyi Göster
          return Consumer<ProductProvider>(
            builder: (ctx, productsData, _) => ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: productsData.items.length,
              itemBuilder: (_, i) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    // Resim yoksa hata vermesin diye kontrol
                    backgroundImage: NetworkImage(productsData.items[i].imageUrl),
                    onBackgroundImageError: (_, __) {}, 
                    child: const Icon(Icons.image_not_supported, size: 10), // Yedek ikon
                  ),
                  title: Text(productsData.items[i].name),
                  subtitle: Text("Stok: ? | Fiyat: ${productsData.items[i].price} ₺"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // DÜZENLEME BUTONU
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (_) => EditProductScreen(product: productsData.items[i]))
                          );
                        },
                      ),
                      // SİLME BUTONU
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Emin misin?"),
                              content: const Text("Bu ürün kalıcı olarak silinecek."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text("İptal"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await Provider.of<ProductProvider>(context, listen: false)
                                        .deleteProduct(productsData.items[i].id);
                                    if (!context.mounted) return;    
                                    Navigator.pop(ctx);
                                    
                                  },
                                  child: const Text("Evet, Sil", style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}