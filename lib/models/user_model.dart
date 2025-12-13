// lib/models/user_model.dart
class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String? address;
  final String role; // 'admin' veya 'user'
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.address,
    this.role = 'user',
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      role: map['role'] ?? 'user',
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}