import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart'; 
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart'; 
import '../screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product; // DÜZELTİLDİ: ProductModel yerine Product
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withAlpha(25), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Hero(
                      tag: "pokemon-${product.id}",
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey, size: 50),
                        ),
                      ),
                    ),
                  ),
                  
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Consumer<FavoritesProvider>(
                      builder: (_, favsProv, __) {
                        final isFav = favsProv.isFavorite(product.id);
                        return IconButton(
                          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                          color: isFav ? Colors.red : Colors.grey.shade400,
                          onPressed: () {
                            favsProv.toggleFavoriteStatus(product);
                          },
                        );
                      },
                    ),
                  ),
                  
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(13),
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(8)),
                      ),
                      child: Text(product.category, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54)),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text("${product.price.toStringAsFixed(0)} ₺", style: const TextStyle(color: Color(0xFFCC0000), fontWeight: FontWeight.bold, fontSize: 16)),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.add, size: 20, color: Colors.white),
                      onPressed: () {
                        cartProvider.addItem(product);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${product.name} eklendi!"), duration: const Duration(milliseconds: 800), behavior: SnackBarBehavior.floating));
                      },
                    ),
                  )
                ]),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}