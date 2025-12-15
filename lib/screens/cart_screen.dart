// lib/screens/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart'; 

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    
    final cartItemsList = cart.items.values.toList(); 
    cartItemsList.sort((a, b) => a.id.compareTo(b.id));

    return Scaffold(
      appBar: AppBar(title: const Text("Sepetim")),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 20),
                  const Text("Sepetin boş!", style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: cartItemsList.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItemsList[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          leading: Container(
                            width: 60,
                            height: 60,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100, 
                              borderRadius: BorderRadius.circular(8)
                            ),
                            child: Image.network(
                              cartItem.product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, _) => const Icon(Icons.image_not_supported),
                            ),
                          ),
                          title: Text(cartItem.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            "${cartItem.product.price.toStringAsFixed(0)} ₺ x ${cartItem.quantity}",
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  cart.removeSingleItem(cartItem.product.id);
                                },
                              ),
                              Text('${cartItem.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  cart.addItem(cartItem.product);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () {
                                  cart.removeItem(cartItem.product.id);
                                },
                              ),
                            ],
                          ),
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
                    boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, -5))],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Toplam:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(
                            "${cart.totalAmount.toStringAsFixed(2)} ₺",
                            style: const TextStyle(fontSize: 24, color: Color(0xFFCC0000), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
                          onPressed: (cart.totalAmount <= 0 || _isLoading)
                              ? null
                              : () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  
                                  final auth = Provider.of<AuthProvider>(context, listen: false);
                                  final user = auth.currentUser;
                                  
                                  if (user == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Sipariş vermek için giriş yapmalısın!"))
                                    );
                                    setState(() => _isLoading = false);
                                    return;
                                  }

                                  try {
                                    // DÜZELTİLDİ: user.address null olamaz (String), bu yüzden isEmpty kontrolü yapıyoruz
                                    final shippingAddress = user.address.isEmpty ? "Adres Girilmemiş" : user.address;

                                    await Provider.of<OrderProvider>(context, listen: false).addOrder(
                                      cartItemsList,
                                      cart.totalAmount,
                                      shippingAddress, 
                                      user.id,
                                      user.email
                                    );
                                    
                                    cart.clear(); 
                                    
                                    if (!context.mounted) return;
                                    setState(() => _isLoading = false);

                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        title: const Text("Sipariş Başarılı! 🚀"),
                                        content: const Text("Siparişin alındı, hazırlanmaya başlandı."),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Harika!"),
                                          )
                                        ],
                                      ),
                                    );
                                  } catch (e) {
                                    setState(() => _isLoading = false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Bir hata oluştu: $e"))
                                    );
                                  }
                                },
                          child: _isLoading 
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text("SATIN AL", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}