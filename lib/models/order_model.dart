// Sipariş durumu için Enum
enum OrderStatus { waiting, preparing, shipping, delivered, cancelled }

class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String imageUrl;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
  
  // Firebase uyumluluğu için
  Map<String, dynamic> toMap() => {
    'productId': productId,
    'productName': productName,
    'price': price,
    'quantity': quantity,
    'imageUrl': imageUrl,
  };
  
  factory OrderItem.fromMap(Map<String, dynamic> map) => OrderItem(
    productId: map['productId'],
    productName: map['productName'],
    price: (map['price'] ?? 0).toDouble(),
    quantity: map['quantity'] ?? 1,
    imageUrl: map['imageUrl'] ?? '',
  );
}

class OrderModel {
  final String id;
  final String userId;
  final String userEmail; // Adminin kimin sipariş verdiğini görmesi için
  final double totalAmount;
  final DateTime orderDate;
  final OrderStatus status; // Enum kullanımı
  final String shippingAddress;
  final List<OrderItem> items;

  OrderModel({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
    required this.shippingAddress,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userEmail': userEmail,
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
      'status': status.name, // Enum'ı string olarak kaydeder (örn: "preparing")
      'shippingAddress': shippingAddress,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['userId'] ?? '',
      userEmail: map['userEmail'] ?? '',
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      orderDate: DateTime.parse(map['orderDate']),
      status: OrderStatus.values.firstWhere(
          (e) => e.name == map['status'], 
          orElse: () => OrderStatus.waiting),
      shippingAddress: map['shippingAddress'] ?? '',
      items: List<OrderItem>.from(
          (map['items'] ?? []).map((x) => OrderItem.fromMap(x))),
    );
  }
}