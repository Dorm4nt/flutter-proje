import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart'; 

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Favori ID'lerini çek
    final favsProvider = Provider.of<FavoritesProvider>(context);
    final favIds = favsProvider.favoriteProductIds;

    // 2. Tüm ürünleri çek (Listen: false, çünkü ürün listesi değişince burası tetiklenmesin)
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    
    // 3. Favori ID'lerine sahip olan ürünleri filtrele
    final favoriteProducts = productProvider.items
        .where((prod) => favIds.contains(prod.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorilerim"),
        backgroundColor: const Color(0xFFCC0000), 
        foregroundColor: Colors.white,
      ),
      body: favoriteProducts.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("Henüz favorin yok kral!", style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: favoriteProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                childAspectRatio: 0.7, // Kart oranı
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (ctx, i) => ProductCard(product: favoriteProducts[i]),
            ),
    );
  }
}