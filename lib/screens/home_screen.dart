import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/main_drawer.dart';
import '../widgets/home_banner.dart';     // YENİ
import '../widgets/home_categories.dart'; // YENİ
import 'cart_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() => _isLoading = true);
      Provider.of<ProductProvider>(context).fetchProducts().then((_) {
        setState(() => _isLoading = false);
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false); 
    final user = auth.currentUser; 
    
    final productProvider = Provider.of<ProductProvider>(context);
    // Kategoriye göre filtrelenmiş ürün listesi:
    final products = productProvider.items; 
    
    final categories = ["Tümü", "Elektrik", "Ateş", "Su", "Çimen", "Efsanevi", "Hayalet", "Normal", "Dövüş"];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Hafif gri arka plan (Modern durur)
      appBar: AppBar(
        title: const Text("PokeMart", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(context: context, delegate: ProductSearchDelegate()),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen())),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Consumer<CartProvider>(
                  builder: (_, cart, ch) => cart.itemCount == 0 
                      ? const SizedBox() 
                      : CircleAvatar(
                          radius: 7,
                          backgroundColor: Colors.red,
                          child: Text('${cart.itemCount}', 
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 5),
        ],
      ),
      drawer: MainDrawer(username: user?.fullName ?? "Misafir"), 
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : SingleChildScrollView( // SAYFAYI KAYDIRILABİLİR YAPTIK
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HERO BANNER
                const HomeBanner(),

                // 2. KATEGORİLER BAŞLIĞI
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text("Kategoriler", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),

                // 3. YATAY KATEGORİ LİSTESİ
                HomeCategories(
                  categories: categories,
                  selectedCategory: productProvider.selectedCategory,
                  onSelect: (cat) {
                     productProvider.setCategory(cat);
                  },
                ),

                const SizedBox(height: 20),

                // 4. ÜRÜNLER BAŞLIĞI
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        productProvider.selectedCategory == "Tümü" 
                            ? "Popüler Ürünler" 
                            : "${productProvider.selectedCategory} Pokemonları", 
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                      Text(
                        "${products.length} Ürün", 
                        style: const TextStyle(color: Colors.grey)
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // 5. ÜRÜN IZGARASI (GRID)
                products.isEmpty
                    ? const SizedBox(
                        height: 200,
                        child: Center(child: Text("Bu kategoride ürün bulunamadı.")),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        // Scroll özelliğini kapatıyoruz çünkü dışarıdaki SingleChildScrollView zaten kaydırıyor
                        physics: const NeverScrollableScrollPhysics(), 
                        shrinkWrap: true, 
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: products.length,
                        itemBuilder: (ctx, i) => ProductCard(product: products[i]),
                      ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }
}

// ARAMA DELEGATE'İ (Aynı kaldı)
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
    Provider.of<ProductProvider>(context, listen: false).search(query);
    close(context, null);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) => const Center(child: Text("Pokemon adı yaz..."));
}