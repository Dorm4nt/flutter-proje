import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/cart_item.dart'; // YENİ: CartItem'ı artık buradan tanıyor

class OrderProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => [..._orders];

  // List<dynamic> yerine artık List<CartItem> kullanıyoruz, çok daha güvenli.
  Future<void> addOrder(List<CartItem> cartProducts, double total, String address, String userId, String userEmail) async {
    
    final newOrder = OrderModel(
      id: DateTime.now().toString(),
      userId: userId,
      userEmail: userEmail,
      totalAmount: total,
      orderDate: DateTime.now(),
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

    _orders.insert(0, newOrder); // En yeni siparişi listenin en başına ekle
    notifyListeners();
    
    // TODO: İleride burada Firebase'e kayıt işlemi yapılacak.
  }

  // Sipariş Durumunu Güncelleme (Admin Paneli İçin)
  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final old = _orders[index];
      _orders[index] = OrderModel(
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
    }
  }
}