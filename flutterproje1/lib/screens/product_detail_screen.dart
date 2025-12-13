import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pokemon_figure.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final PokemonFigure product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: Center(
              child: Hero(tag: "pokemon-${product.id}", child: Image.network(product.imageUrl, height: 250)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(product.category.toUpperCase(), style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    Text(product.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ]),
                  Text("${product.price.toStringAsFixed(0)} ₺", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFFCC0000))),
                ]),
                const SizedBox(height: 20),
                const Text("Ürün Açıklaması", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(product.description, style: const TextStyle(color: Colors.grey, height: 1.5, fontSize: 15)),
                const Spacer(),
                Row(children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCC0000),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 5,
                      ),
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false).addToCart(product);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sepete eklendi!"), backgroundColor: Colors.green));
                      },
                      child: const Text("SEPETE EKLE", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ]),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
