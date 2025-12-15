// lib/providers/order_provider.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../models/cart_item.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];

  List<OrderModel> get orders => [..._orders];

  Future<void> addOrder(List<CartItem> cartProducts, double total, String address, String userId, String userEmail) async {
    final docRef = FirebaseFirestore.instance.collection('orders').doc();
    final timestamp = DateTime.now(); 

    final newOrder = OrderModel(
      id: docRef.id,
      userId: userId,
      userEmail: userEmail,
      totalAmount: total,
      orderDate: timestamp, 
      status: OrderStatus.waiting,
      shippingAddress: address,
      items: cartProducts.map((cp) => OrderItem(
        productId: cp.product.id,
        productName: cp.product.name,
        price: cp.product.price,
        quantity: cp.quantity,
        imageUrl: cp.product.imageUrl,
      )).toList(),
    );

    try {
      await docRef.set({
        ...newOrder.toMap(), 
        'orderDate': FieldValue.serverTimestamp(), 
      });

      _orders.insert(0, newOrder);
      notifyListeners();
    } catch (e) {
      debugPrint("Sipariş eklenirken hata: $e");
      rethrow;
    }
  }

  Future<void> fetchOrders(String? userId, {bool isAdmin = false}) async {
    // 🔥 EĞER USER ID YOKSA VE ADMİN DEĞİLSE HİÇ SORGU YAPMA (BOŞUNA DONMASIN)
    if (!isAdmin && userId == null) {
      _orders = [];
      notifyListeners();
      return;
    }

    try {
      Query query = FirebaseFirestore.instance.collection('orders');

      if (!isAdmin && userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }
      
      // 🔥 DİKKAT: Firestore'da 'userId' filtresi ile 'orderDate' sıralaması aynı anda
      // kullanıldığında İNDEKS OLUŞTURMAN gerekir.
      // Eğer uygulama donuyor ve konsolda "The query requires an index" linki çıkıyorsa
      // o linke tıklayıp indeksi oluşturmalısın.
      query = query.orderBy('orderDate', descending: true);
      
      final snapshot = await query.get();

      final List<OrderModel> loadedOrders = [];
      for (var doc in snapshot.docs) {
        // null check yaparak ekle
        if (doc.data() != null) {
           loadedOrders.add(OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id));
        }
      }

      _orders = loadedOrders;
      notifyListeners();
    } catch (e) {
      debugPrint("Siparişler çekilemedi: $e");
      // Hata olsa bile listeyi boşalt ki sonsuz döngüde kalmasın
      _orders = [];
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    final orderIndex = _orders.indexWhere((o) => o.id == orderId);
    if (orderIndex >= 0) {
      try {
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .update({'status': newStatus.name}); // Enum name string olarak kaydedilir

        final old = _orders[orderIndex];
        _orders[orderIndex] = OrderModel(
          id: old.id,
          userId: old.userId,
          userEmail: old.userEmail,
          totalAmount: old.totalAmount,
          orderDate: old.orderDate,
          status: newStatus,
          shippingAddress: old.shippingAddress,
          items: old.items,
        );
        notifyListeners();
      } catch (e) {
        debugPrint("Durum güncellenemedi: $e");
        rethrow;
      }
    }
  }
}