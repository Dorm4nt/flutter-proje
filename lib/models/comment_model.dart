// lib/models/comment_model.dart
class Comment {
  final String id;
  final String userId;
  final String userName;
  final String productId;
  final String content;
  final double rating; // 1-5 arası
  final DateTime date;
  final bool isApproved; // Admin onayı için

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.productId,
    required this.content,
    required this.rating,
    required this.date,
    this.isApproved = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'productId': productId,
      'content': content,
      'rating': rating,
      'date': date.toIso8601String(),
      'isApproved': isApproved,
    };
  }
  
  // factory fromMap kısmını da sen eklersin veya lazım olunca yazarız.
}