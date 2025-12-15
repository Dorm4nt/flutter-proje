// lib/screens/orders_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; 
import '../providers/order_provider.dart';
import '../models/order_model.dart'; 
import '../providers/auth_provider.dart'; // AuthProvider'ı ekledik
import '../widgets/main_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    // 🔥 DÜZELTME: AuthProvider'dan o anki kullanıcının ID'sini alıyoruz
    final authData = Provider.of<AuthProvider>(context, listen: false);
    
    // Eğer kullanıcı giriş yapmamışsa (null ise) boş dönmesin diye kontrol
    final userId = authData.currentUser?.id;

    if (userId == null) {
      // Kullanıcı yoksa hata fırlatmadan boş future döndür
      return Future.value();
    }

    // null yerine userId gönderiyoruz
    return Provider.of<OrderProvider>(context, listen: false).fetchOrders(userId, isAdmin: false);
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Siparişlerim'),
        backgroundColor: const Color(0xFFCC0000),
        foregroundColor: Colors.white,
      ),
      drawer: MainDrawer(username: "Kullanıcı"), 
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (dataSnapshot.error != null) {
            debugPrint("Sipariş Hatası: ${dataSnapshot.error}"); // Hatayı konsola yazdır
            return const Center(child: Text('Bir hata oluştu!'));
          } else {
            return Consumer<OrderProvider>(
              builder: (ctx, orderData, child) {
                if (orderData.orders.isEmpty) {
                  return const Center(child: Text("Henüz siparişin yok kral."));
                }
                return ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItemCard(order: orderData.orders[i]),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class OrderItemCard extends StatefulWidget {
  final OrderModel order;
  const OrderItemCard({super.key, required this.order});

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    String dateStr = "Tarih Yok";
    // orderDate null gelme ihtimaline karşı koruma
    try {
      dateStr = DateFormat('dd/MM/yyyy HH:mm').format(widget.order.orderDate);
    } catch (e) {
      dateStr = "Hatalı Tarih";
    }

    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('${widget.order.totalAmount.toStringAsFixed(2)} ₺', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(dateStr),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(widget.order.status),
              child: const Icon(Icons.shopping_bag, color: Colors.white, size: 20),
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: widget.order.items.length * 30.0 + 20, 
              child: ListView(
                physics: const NeverScrollableScrollPhysics(), 
                children: widget.order.items
                    .map(
                      (prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            prod.productName, 
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${prod.quantity}x ${prod.price} ₺',
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          )
                        ],
                      ),
                    )
                    .toList(),
              ),
            )
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.waiting: return Colors.orange;
      case OrderStatus.confirmed: return Colors.blue;
      case OrderStatus.shipped: return Colors.purple;
      case OrderStatus.delivered: return Colors.green;
      case OrderStatus.cancelled: return Colors.red;
      default: return Colors.grey;
    }
  }
}