class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? photoUrl;
  final String userType; // 'client', 'barber' ou 'owner'
  final String barbershopId; // ID da barbearia
  final String? cpfCnpj; // CPF/CNPJ (apenas para proprietários)
  final String? address; // Endereço completo (apenas para proprietários)
  final String? barbershopName; // Nome da barbearia (apenas para proprietários)
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photoUrl,
    required this.userType,
    required this.barbershopId,
    this.cpfCnpj,
    this.address,
    this.barbershopName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      photoUrl: json['photoUrl'],
      userType: json['userType'] ?? 'client',
      barbershopId: json['barbershopId'] ?? '',
      cpfCnpj: json['cpfCnpj'],
      address: json['address'],
      barbershopName: json['barbershopName'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'userType': userType,
      'barbershopId': barbershopId,
      'cpfCnpj': cpfCnpj,
      'address': address,
      'barbershopName': barbershopName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? userType,
    String? barbershopId,
    String? cpfCnpj,
    String? address,
    String? barbershopName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      userType: userType ?? this.userType,
      barbershopId: barbershopId ?? this.barbershopId,
      cpfCnpj: cpfCnpj ?? this.cpfCnpj,
      address: address ?? this.address,
      barbershopName: barbershopName ?? this.barbershopName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
