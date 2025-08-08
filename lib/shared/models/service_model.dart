class ServiceModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final int duration; // duração em minutos
  final String barbershopId;
  final bool isActive;
  final List<String> availableDays; // ['monday', 'tuesday', etc.]
  final Map<String, List<String>>
  availableHours; // {'monday': ['09:00', '10:00']}
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.barbershopId,
    this.isActive = true,
    this.availableDays = const [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
    ],
    this.availableHours = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      duration: json['duration'] ?? 30,
      barbershopId: json['barbershopId'] ?? '',
      isActive: json['isActive'] ?? true,
      availableDays: List<String>.from(
        json['availableDays'] ??
            [
              'monday',
              'tuesday',
              'wednesday',
              'thursday',
              'friday',
              'saturday',
            ],
      ),
      availableHours: Map<String, List<String>>.from(
        json['availableHours'] ?? {},
      ),
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
      'price': price,
      'duration': duration,
      'barbershopId': barbershopId,
      'isActive': isActive,
      'availableDays': availableDays,
      'availableHours': availableHours,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ServiceModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? duration,
    String? barbershopId,
    bool? isActive,
    List<String>? availableDays,
    Map<String, List<String>>? availableHours,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      barbershopId: barbershopId ?? this.barbershopId,
      isActive: isActive ?? this.isActive,
      availableDays: availableDays ?? this.availableDays,
      availableHours: availableHours ?? this.availableHours,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Formatar duração para exibição
  String get formattedDuration {
    if (duration < 60) {
      return '${duration}min';
    } else {
      final hours = duration ~/ 60;
      final minutes = duration % 60;
      if (minutes == 0) {
        return '${hours}h';
      } else {
        return '${hours}h ${minutes}min';
      }
    }
  }

  // Formatar preço para exibição
  String get formattedPrice {
    return 'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}
