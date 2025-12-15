// lib/models/user_model.dart

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String userType; // Role yerine userType
  final String phoneNumber;
  final String address;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.userType,
    this.phoneNumber = '', 
    this.address = '',     
  });

  // Firestore'dan veri çekerken
  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      id: documentId,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      // Hem 'userType' hem 'role' alanını kontrol edip hata riskini sıfıra indirdik
      userType: data['userType'] ?? data['role'] ?? 'user', 
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'] ?? '',
    );
  }

  // Firestore'a veri yazarken
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'userType': userType,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }
}