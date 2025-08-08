class TimeSlotModel {
  final String id;
  final DateTime date;
  final String time; // formato "HH:mm"
  final int duration; // duração em minutos
  final String barbershopId;
  final String barberId;
  final bool isAvailable;
  final String? appointmentId; // se não for null, está ocupado
  final DateTime createdAt;
  final DateTime updatedAt;

  TimeSlotModel({
    required this.id,
    required this.date,
    required this.time,
    required this.duration,
    required this.barbershopId,
    required this.barberId,
    this.isAvailable = true,
    this.appointmentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      time: json['time'] ?? '',
      duration: json['duration'] ?? 30,
      barbershopId: json['barbershopId'] ?? '',
      barberId: json['barberId'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      appointmentId: json['appointmentId'],
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
      'date': date.toIso8601String(),
      'time': time,
      'duration': duration,
      'barbershopId': barbershopId,
      'barberId': barberId,
      'isAvailable': isAvailable,
      'appointmentId': appointmentId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  TimeSlotModel copyWith({
    String? id,
    DateTime? date,
    String? time,
    int? duration,
    String? barbershopId,
    String? barberId,
    bool? isAvailable,
    String? appointmentId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TimeSlotModel(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      duration: duration ?? this.duration,
      barbershopId: barbershopId ?? this.barbershopId,
      barberId: barberId ?? this.barberId,
      isAvailable: isAvailable ?? this.isAvailable,
      appointmentId: appointmentId ?? this.appointmentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Verificar se o horário está disponível
  bool get isFree => isAvailable && appointmentId == null;

  // Obter DateTime completo do horário
  DateTime get fullDateTime {
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  // Obter horário de fim
  DateTime get endDateTime {
    return fullDateTime.add(Duration(minutes: duration));
  }

  // Formatar horário para exibição
  String get formattedTime {
    return time;
  }

  // Formatar data para exibição
  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Formatar data e hora para exibição
  String get formattedDateTime {
    return '$formattedDate às $formattedTime';
  }
}

