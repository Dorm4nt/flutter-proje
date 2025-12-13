import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/main_drawer.dart';
import '../widgets/category_filter_bar.dart';
import 'cart_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider'ı yerel değişkene atadık.
    final auth = Provider.of<AuthProvider>(context, listen: false); 
    final user = auth.currentUser; 
    
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.items; 

    final categories = ["Tümü", "Elektrik", "Ateş", "Su", "Çimen", "Efsanevi", "Hayalet", "Normal", "Dövüş"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("PokeMart"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Arama butonuna basılınca delegat'ı çağırır
              showSearch(context: context, delegate: ProductSearchDelegate());
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, size: 28),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Consumer<CartProvider>(
                  builder: (_, cart, ch) => cart.itemCount == 0 
                      ? const SizedBox() 
                      : CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.yellow,
                          child: Text('${cart.itemCount}', 
                              style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      // Null kontrolü ile kullanıcı adı veya "Misafir" gönderilir
      drawer: MainDrawer(username: user?.fullName ?? "Misafir"), 
      body: Column(
        children: [
          CategoryFilterBar(
            categories: categories,
            selected: productProvider.selectedCategory,
            onSelected: (cat) {
               productProvider.setCategory(cat);
            },
          ),
          Expanded(
            child: products.isEmpty
                ? const Center(child: Text("Ürün bulunamadı."))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: products.length,
                    itemBuilder: (ctx, i) => ProductCard(product: products[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

// ARama Delegesi Sınıfı
class ProductSearchDelegate extends SearchDelegate {
  
  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null)
  );

  @override
  Widget buildResults(BuildContext context) {
    // Provider'a arama sorgusunu gönder
    Provider.of<ProductProvider>(context, listen: false).search(query);
    
    // Arama ekranını kapat
    close(context, null);
    
    // HATA DÜZELTİLDİ: buildResults null dönemez.
    // Arama sonucu Home Screen'de gösterileceği için boş bir widget döndürmemiz yeterli.
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) => const Center(child: Text("Pokemon adı yaz..."));
}