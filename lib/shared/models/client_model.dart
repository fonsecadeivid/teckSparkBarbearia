class ClientModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String barbershopId;
  final String? photoUrl;
  final String? localPhotoPath; // Caminho local da foto
  final DateTime? birthDate; // Data de nascimento
  final DateTime createdAt;
  final DateTime updatedAt;

  ClientModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.barbershopId,
    this.photoUrl,
    this.localPhotoPath,
    this.birthDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      barbershopId: json['barbershopId'] ?? '',
      photoUrl: json['photoUrl'],
      localPhotoPath: json['localPhotoPath'],
      birthDate: json['birthDate'] != null 
          ? DateTime.parse(json['birthDate'])
          : null,
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
      'barbershopId': barbershopId,
      'photoUrl': photoUrl,
      'localPhotoPath': localPhotoPath,
      'birthDate': birthDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ClientModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? barbershopId,
    String? photoUrl,
    String? localPhotoPath,
    DateTime? birthDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      barbershopId: barbershopId ?? this.barbershopId,
      photoUrl: photoUrl ?? this.photoUrl,
      localPhotoPath: localPhotoPath ?? this.localPhotoPath,
      birthDate: birthDate ?? this.birthDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Calcular idade
  int? get age {
    if (birthDate == null) return null;
    final now = DateTime.now();
    int age = now.year - birthDate!.year;
    if (now.month < birthDate!.month || 
        (now.month == birthDate!.month && now.day < birthDate!.day)) {
      age--;
    }
    return age;
  }

  // Verificar se é aniversário hoje
  bool get isBirthdayToday {
    if (birthDate == null) return false;
    final now = DateTime.now();
    return now.month == birthDate!.month && now.day == birthDate!.day;
  }

  // Verificar se é aniversário nos próximos X dias
  bool isBirthdayInNextDays(int days) {
    if (birthDate == null) return false;
    final now = DateTime.now();
    final nextBirthday = DateTime(now.year, birthDate!.month, birthDate!.day);
    
    // Se o aniversário já passou este ano, verificar para o próximo ano
    if (nextBirthday.isBefore(now)) {
      final nextYearBirthday = DateTime(now.year + 1, birthDate!.month, birthDate!.day);
      final difference = nextYearBirthday.difference(now).inDays;
      return difference <= days;
    } else {
      final difference = nextBirthday.difference(now).inDays;
      return difference <= days;
    }
  }

  // Formatar data de nascimento para exibição
  String? get formattedBirthDate {
    if (birthDate == null) return null;
    return '${birthDate!.day.toString().padLeft(2, '0')}/${birthDate!.month.toString().padLeft(2, '0')}/${birthDate!.year}';
  }
}

