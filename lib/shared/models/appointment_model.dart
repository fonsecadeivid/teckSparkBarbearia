enum AppointmentStatus { pending, confirmed, completed, cancelled }

class AppointmentModel {
  final String id;
  final String clientId;
  final String barberId;
  final String serviceId;
  final String barbershopId;
  final DateTime scheduledDate;
  final String scheduledTime; // formato "HH:mm"
  final int duration; // duração em minutos
  final AppointmentStatus status;
  final double totalPrice;
  final String? notes;
  final String? clientName; // para facilitar consultas
  final String? serviceName; // para facilitar consultas
  final String? barberName; // para facilitar consultas
  final DateTime createdAt;
  final DateTime updatedAt;

  AppointmentModel({
    required this.id,
    required this.clientId,
    required this.barberId,
    required this.serviceId,
    required this.barbershopId,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.duration,
    this.status = AppointmentStatus.pending,
    required this.totalPrice,
    this.notes,
    this.clientName,
    this.serviceName,
    this.barberName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] ?? '',
      clientId: json['clientId'] ?? '',
      barberId: json['barberId'] ?? '',
      serviceId: json['serviceId'] ?? '',
      barbershopId: json['barbershopId'] ?? '',
      scheduledDate: DateTime.parse(
        json['scheduledDate'] ?? DateTime.now().toIso8601String(),
      ),
      scheduledTime: json['scheduledTime'] ?? '',
      duration: json['duration'] ?? 30,
      status: AppointmentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => AppointmentStatus.pending,
      ),
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      notes: json['notes'],
      clientName: json['clientName'],
      serviceName: json['serviceName'],
      barberName: json['barberName'],
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
      'clientId': clientId,
      'barberId': barberId,
      'serviceId': serviceId,
      'barbershopId': barbershopId,
      'scheduledDate': scheduledDate.toIso8601String(),
      'scheduledTime': scheduledTime,
      'duration': duration,
      'status': status.toString().split('.').last,
      'totalPrice': totalPrice,
      'notes': notes,
      'clientName': clientName,
      'serviceName': serviceName,
      'barberName': barberName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  AppointmentModel copyWith({
    String? id,
    String? clientId,
    String? barberId,
    String? serviceId,
    String? barbershopId,
    DateTime? scheduledDate,
    String? scheduledTime,
    int? duration,
    AppointmentStatus? status,
    double? totalPrice,
    String? notes,
    String? clientName,
    String? serviceName,
    String? barberName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      barberId: barberId ?? this.barberId,
      serviceId: serviceId ?? this.serviceId,
      barbershopId: barbershopId ?? this.barbershopId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      notes: notes ?? this.notes,
      clientName: clientName ?? this.clientName,
      serviceName: serviceName ?? this.serviceName,
      barberName: barberName ?? this.barberName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Obter DateTime completo do agendamento
  DateTime get fullScheduledDateTime {
    final timeParts = scheduledTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    return DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      hour,
      minute,
    );
  }

  // Obter horário de fim
  DateTime get endDateTime {
    return fullScheduledDateTime.add(Duration(minutes: duration));
  }

  // Formatar data para exibição
  String get formattedDate {
    return '${scheduledDate.day.toString().padLeft(2, '0')}/${scheduledDate.month.toString().padLeft(2, '0')}/${scheduledDate.year}';
  }

  // Formatar data e hora para exibição
  String get formattedDateTime {
    return '$formattedDate às $scheduledTime';
  }

  // Formatar status para exibição
  String get formattedStatus {
    switch (status) {
      case AppointmentStatus.pending:
        return 'Pendente';
      case AppointmentStatus.confirmed:
        return 'Confirmado';
      case AppointmentStatus.completed:
        return 'Concluído';
      case AppointmentStatus.cancelled:
        return 'Cancelado';
    }
  }

  // Formatar preço para exibição
  String get formattedPrice {
    return 'R\$ ${totalPrice.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  // Verificar se o agendamento é hoje
  bool get isToday {
    final now = DateTime.now();
    return scheduledDate.year == now.year &&
        scheduledDate.month == now.month &&
        scheduledDate.day == now.day;
  }

  // Verificar se o agendamento é no futuro
  bool get isFuture {
    return fullScheduledDateTime.isAfter(DateTime.now());
  }

  // Verificar se o agendamento é no passado
  bool get isPast {
    return fullScheduledDateTime.isBefore(DateTime.now());
  }
}
