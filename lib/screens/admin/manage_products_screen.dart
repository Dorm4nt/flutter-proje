import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import 'edit_product_screen.dart';

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).items;

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
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        itemBuilder: (_, i) => Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(products[i].imageUrl)),
            title: Text(products[i].name),
            subtitle: Text("Stok: ${products[i].stock} | Fiyat: ${products[i].price} ₺"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditProductScreen(product: products[i]))),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Silme onayı
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Emin misin?"),
                        content: const Text("Bu ürün silinecek."),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Hayır")),
                          TextButton(
                            onPressed: () {
                              Provider.of<ProductProvider>(context, listen: false).deleteProduct(products[i].id);
                              Navigator.pop(ctx);
                            },
                            child: const Text("Evet, Sil"),
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
  }
}