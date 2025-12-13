import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order_model.dart';
// BURADA INTL IMPORTU YOK!

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider null dönerse diye önlem alalım, ama normalde dönmez.
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;

    return Scaffold(
      appBar: AppBar(title: const Text("Sipariş Yönetimi")),
      body: orders.isEmpty 
        ? const Center(child: Text("Henüz sipariş yok.")) 
        : ListView.builder(
          itemCount: orders.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (ctx, i) {
            final order = orders[i]; // Kodu sadeleştirmek için değişkene atadık
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                title: Text("${order.totalAmount.toStringAsFixed(0)} ₺ - ${order.userEmail}"),
                subtitle: Text("Durum: ${order.status.name.toUpperCase()} \nAdres: ${order.shippingAddress}"),
                children: [
                  // Ürünler Listesi
                  ...order.items.map((item) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(item.imageUrl),
                      onBackgroundImageError: (_, __) => const Icon(Icons.error), 
                    ),
                    title: Text(item.productName),
                    trailing: Text("${item.quantity} x ${item.price} ₺"),
                  )),
                  
                  // Durum Güncelleme Butonu
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Durumu Güncelle:", style: TextStyle(fontWeight: FontWeight.bold)),
                        DropdownButton<OrderStatus>(
                          value: order.status,
                          items: OrderStatus.values.map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s.name.toUpperCase()),
                          )).toList(),
                          onChanged: (newStatus) {
                            if (newStatus != null) {
                              // Provider'ı listen: false ile çağırıyoruz ki döngüye girmesin
                              Provider.of<OrderProvider>(context, listen: false).updateOrderStatus(order.id, newStatus);
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
    );
  }
}