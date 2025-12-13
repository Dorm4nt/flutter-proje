import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Sepetim")),
      body: cart.cartItems.isEmpty
          ? Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade300),
              const SizedBox(height: 20),
              const Text("Sepetin boş!", style: TextStyle(fontSize: 18, color: Colors.grey))
            ]))
          : Column(children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: cart.cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cart.cartItems[index]; // CartItem
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        leading: Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                          child: Image.network(cartItem.product.imageUrl),
                        ),
                        title: Text(cartItem.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${cartItem.product.price.toStringAsFixed(0)} ₺ x ${cartItem.quantity}", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(onPressed: () => cart.decreaseFromCart(cartItem.product), icon: const Icon(Icons.remove)),
                          Text('${cartItem.quantity}'),
                          IconButton(onPressed: () => cart.addToCart(cartItem.product), icon: const Icon(Icons.add)),
                          IconButton(onPressed: () => cart.removeFromCart(cartItem.product), icon: const Icon(Icons.delete_outline, color: Colors.red)),
                        ]),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
                ),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text("Toplam:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("${cart.totalPrice.toStringAsFixed(0)} ₺", style: const TextStyle(fontSize: 24, color: Color(0xFFCC0000), fontWeight: FontWeight.bold)),
                  ]),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        cart.clearCart();
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  title: const Text("Sipariş Başarılı! 🚀"),
                                  content: const Text("Pokemonların yola çıktı, kargo takip numarası SMS olarak gelecek."),
                                  actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Harika!"))],
                                ));
                      },
                      child: const Text("SATIN AL", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                ]),
              )
            ]),
    );
  }
}
