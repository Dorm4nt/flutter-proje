import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Tarih formatı için
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order_model.dart'; // Enum'a erişmek için (OrderStatus)

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sipariş Yönetimi"),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Siparişleri tarihe göre (yeni en üstte) çekiyoruz
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('orderDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          }

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 60, color: Colors.grey),
                  Text("Henüz sipariş yok"),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderDoc = orders[index];
              final orderData = orderDoc.data() as Map<String, dynamic>;
              final orderId = orderDoc.id;

              // --- VERİ HAZIRLIĞI ---
              
              // 1. Tarih
              String dateStr = "Tarih Yok";
              if (orderData['orderDate'] is Timestamp) {
                dateStr = DateFormat('dd MMM yyyy HH:mm').format((orderData['orderDate'] as Timestamp).toDate());
              }

              // 2. Müşteri Bilgisi (Email varsa onu göster, yoksa ID)
              final customerInfo = orderData['userEmail'] ?? "ID: ${orderData['userId']}";

              // 3. Durum (Status)
              String statusStr = orderData['status'] ?? 'waiting'; 
              
              // 4. Toplam Tutar
              final totalAmount = orderData['totalAmount'].toString();

              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  // Sol ikon: Duruma göre renk değiştirir
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(statusStr),
                    child: const Icon(Icons.shopping_bag, color: Colors.white),
                  ),
                  title: Text(
                    "Tutar: $totalAmount ₺",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text("Müşteri: $customerInfo", style: const TextStyle(fontSize: 12)),
                      Text(dateStr, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      // Durum Göstergesi (Subtitle içinde)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getStatusColor(statusStr).withAlpha(50), // withOpacity yerine withAlpha güvenli
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: _getStatusColor(statusStr), width: 1),
                        ),
                        child: Text(
                          _getStatusTr(statusStr),
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _getStatusColor(statusStr)),
                        ),
                      ),
                    ],
                  ),
                  children: [
                    const Divider(),
                    // --- SİPARİŞ DURUMU GÜNCELLEME ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Sipariş Durumu:", style: TextStyle(fontWeight: FontWeight.bold)),
                          DropdownButton<String>(
                            value: ['waiting', 'confirmed', 'shipped', 'delivered', 'cancelled'].contains(statusStr) ? statusStr : 'waiting',
                            underline: Container(height: 2, color: Colors.blue),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                // Durumu güncelle
                                Provider.of<OrderProvider>(context, listen: false)
                                    .updateOrderStatus(orderId, _parseStatus(newValue));
                              }
                            },
                            items: [
                              DropdownMenuItem(value: 'waiting', child: Text("Bekliyor")),
                              DropdownMenuItem(value: 'confirmed', child: Text("Onaylandı")),
                              DropdownMenuItem(value: 'shipped', child: Text("Kargolandı")),
                              DropdownMenuItem(value: 'delivered', child: Text("Teslim Edildi")),
                              DropdownMenuItem(value: 'cancelled', child: Text("İptal Edildi", style: TextStyle(color: Colors.red))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    
                    // --- ÜRÜN LİSTESİ ---
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200), // Çok ürün varsa scroll olsun
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: (orderData['items'] as List).length,
                        itemBuilder: (ctx, i) {
                          final item = (orderData['items'] as List)[i];
                          // İsim düzeltmesi: productName yoksa title, o da yoksa 'Ürün'
                          final prodName = item['productName'] ?? item['title'] ?? 'Ürün';
                          final prodPrice = item['price'];
                          final prodQty = item['quantity'] ?? 1;
                          final prodImg = item['imageUrl'];

                          return ListTile(
                            leading: prodImg != null 
                                ? Image.network(prodImg, width: 40, height: 40, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.image))
                                : const Icon(Icons.image_not_supported),
                            title: Text(prodName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            trailing: Text("$prodQty x $prodPrice ₺"),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Yardımcı: Durum rengi
  Color _getStatusColor(String status) {
    switch (status) {
      case 'waiting': return Colors.orange;
      case 'confirmed': return Colors.blue;
      case 'shipped': return Colors.purple;
      case 'delivered': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  // Yardımcı: Türkçe Durum Metni
  String _getStatusTr(String status) {
    switch (status) {
      case 'waiting': return "Bekliyor";
      case 'confirmed': return "Onaylandı";
      case 'shipped': return "Kargolandı";
      case 'delivered': return "Teslim Edildi";
      case 'cancelled': return "İptal";
      default: return status;
    }
  }

  // Yardımcı: String'den Enum'a çevirme (Provider için)
  OrderStatus _parseStatus(String statusStr) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == statusStr, 
      orElse: () => OrderStatus.waiting
    );
  }
}