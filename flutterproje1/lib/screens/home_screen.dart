import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/main_drawer.dart';
import '../widgets/category_filter_bar.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = "Tümü";
  final List<String> categories = ["Tümü", "Elektrik", "Ateş", "Su", "Çimen", "Hayalet", "Efsanevi", "Dövüş", "Normal"];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);
    final products = provider.getProductsByCategory(selectedCategory);

    return Scaffold(
      appBar: AppBar(
        title: const Text("PokeMart"),
        actions: [
          Stack(alignment: Alignment.center, children: [
            IconButton(icon: const Icon(Icons.shopping_bag_outlined, size: 28), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()))),
            if (provider.cartItems.isNotEmpty)
              Positioned(right: 8, top: 8, child: CircleAvatar(radius: 8, backgroundColor: Colors.yellow, child: Text('${provider.cartItems.length}', style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)))),
          ]),
          const SizedBox(width: 8),
        ],
      ),
      drawer: MainDrawer(username: widget.username),
      body: Column(children: [
        CategoryFilterBar(categories: categories, selected: selectedCategory, onSelected: (cat) => setState(() => selectedCategory = cat)),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7, crossAxisSpacing: 12, mainAxisSpacing: 12),
            itemCount: products.length,
            itemBuilder: (context, index) => ProductCard(product: products[index]),
          ),
        )
      ]),
    );
  }
}
