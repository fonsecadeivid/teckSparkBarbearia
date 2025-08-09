class BarbershopModel {
  final String id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final String email;
  final String? photoUrl;
  final String ownerId; // ID do dono da barbearia
  final List<String> barberIds; // IDs dos barbeiros
  final List<String> serviceIds; // IDs dos serviços
  final Map<String, dynamic> businessHours; // Horários de funcionamento
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  BarbershopModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
    this.photoUrl,
    required this.ownerId,
    this.barberIds = const [],
    this.serviceIds = const [],
    this.businessHours = const {},
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BarbershopModel.fromJson(Map<String, dynamic> json) {
    return BarbershopModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'],
      ownerId: json['ownerId'] ?? '',
      barberIds: List<String>.from(json['barberIds'] ?? []),
      serviceIds: List<String>.from(json['serviceIds'] ?? []),
      businessHours: Map<String, dynamic>.from(json['businessHours'] ?? {}),
      isActive: json['isActive'] ?? true,
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
      'description': description,
      'address': address,
      'phone': phone,
      'email': email,
      'photoUrl': photoUrl,
      'ownerId': ownerId,
      'barberIds': barberIds,
      'serviceIds': serviceIds,
      'businessHours': businessHours,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  BarbershopModel copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    String? phone,
    String? email,
    String? photoUrl,
    String? ownerId,
    List<String>? barberIds,
    List<String>? serviceIds,
    Map<String, dynamic>? businessHours,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BarbershopModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      ownerId: ownerId ?? this.ownerId,
      barberIds: barberIds ?? this.barberIds,
      serviceIds: serviceIds ?? this.serviceIds,
      businessHours: businessHours ?? this.businessHours,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
