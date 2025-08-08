import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/appointment_model.dart';
import '../models/time_slot_model.dart';
import '../models/service_model.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // Criar novo agendamento
  Future<AppointmentModel> createAppointment({
    required String clientId,
    required String barberId,
    required String serviceId,
    required String barbershopId,
    required DateTime scheduledDate,
    required String scheduledTime,
    required int duration,
    required double totalPrice,
    String? notes,
    String? clientName,
    String? serviceName,
    String? barberName,
  }) async {
    try {
      final String appointmentId = _uuid.v4();

      final AppointmentModel appointment = AppointmentModel(
        id: appointmentId,
        clientId: clientId,
        barberId: barberId,
        serviceId: serviceId,
        barbershopId: barbershopId,
        scheduledDate: scheduledDate,
        scheduledTime: scheduledTime,
        duration: duration,
        totalPrice: totalPrice,
        notes: notes,
        clientName: clientName,
        serviceName: serviceName,
        barberName: barberName,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Criar o agendamento
      await _firestore
          .collection('appointments')
          .doc(appointmentId)
          .set(appointment.toJson());

      // Criar/atualizar time slot
      await _createOrUpdateTimeSlot(
        appointmentId: appointmentId,
        date: scheduledDate,
        time: scheduledTime,
        duration: duration,
        barbershopId: barbershopId,
        barberId: barberId,
      );

      return appointment;
    } catch (e) {
      throw 'Erro ao criar agendamento: $e';
    }
  }

  // Criar ou atualizar time slot
  Future<void> _createOrUpdateTimeSlot({
    required String appointmentId,
    required DateTime date,
    required String time,
    required int duration,
    required String barbershopId,
    required String barberId,
  }) async {
    try {
      final String timeSlotId =
          '${barberId}_${date.toIso8601String().split('T')[0]}_$time';

      final TimeSlotModel timeSlot = TimeSlotModel(
        id: timeSlotId,
        date: date,
        time: time,
        duration: duration,
        barbershopId: barbershopId,
        barberId: barberId,
        isAvailable: false,
        appointmentId: appointmentId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('time_slots')
          .doc(timeSlotId)
          .set(timeSlot.toJson());
    } catch (e) {
      throw 'Erro ao criar time slot: $e';
    }
  }

  // Buscar agendamento por ID
  Future<AppointmentModel?> getAppointmentById(String appointmentId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('appointments')
          .doc(appointmentId)
          .get();

      if (doc.exists) {
        return AppointmentModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw 'Erro ao buscar agendamento: $e';
    }
  }

  // Buscar agendamentos por barbearia
  Future<List<AppointmentModel>> getAppointmentsByBarbershop(
    String barbershopId,
  ) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('appointments')
          .where('barbershopId', isEqualTo: barbershopId)
          .orderBy('scheduledDate', descending: true)
          .orderBy('scheduledTime')
          .get();

      return querySnapshot.docs
          .map(
            (doc) =>
                AppointmentModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw 'Erro ao buscar agendamentos: $e';
    }
  }

  // Buscar agendamentos por cliente
  Future<List<AppointmentModel>> getAppointmentsByClient(
    String clientId,
  ) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('appointments')
          .where('clientId', isEqualTo: clientId)
          .orderBy('scheduledDate', descending: true)
          .orderBy('scheduledTime')
          .get();

      return querySnapshot.docs
          .map(
            (doc) =>
                AppointmentModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw 'Erro ao buscar agendamentos do cliente: $e';
    }
  }

  // Buscar agendamentos por barbeiro
  Future<List<AppointmentModel>> getAppointmentsByBarber(
    String barberId,
  ) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('appointments')
          .where('barberId', isEqualTo: barberId)
          .orderBy('scheduledDate', descending: true)
          .orderBy('scheduledTime')
          .get();

      return querySnapshot.docs
          .map(
            (doc) =>
                AppointmentModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw 'Erro ao buscar agendamentos do barbeiro: $e';
    }
  }

  // Buscar agendamentos por data
  Future<List<AppointmentModel>> getAppointmentsByDate(
    DateTime date,
    String barbershopId,
  ) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final QuerySnapshot querySnapshot = await _firestore
          .collection('appointments')
          .where('barbershopId', isEqualTo: barbershopId)
          .where('scheduledDate', isGreaterThanOrEqualTo: startOfDay)
          .where('scheduledDate', isLessThan: endOfDay)
          .orderBy('scheduledTime')
          .get();

      return querySnapshot.docs
          .map(
            (doc) =>
                AppointmentModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw 'Erro ao buscar agendamentos por data: $e';
    }
  }

  // Atualizar agendamento
  Future<void> updateAppointment(AppointmentModel appointment) async {
    try {
      final updatedAppointment = appointment.copyWith(
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('appointments')
          .doc(appointment.id)
          .update(updatedAppointment.toJson());
    } catch (e) {
      throw 'Erro ao atualizar agendamento: $e';
    }
  }

  // Cancelar agendamento
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': 'cancelled',
        'updatedAt': DateTime.now().toIso8601String(),
      });

      // Liberar time slot
      await _releaseTimeSlot(appointmentId);
    } catch (e) {
      throw 'Erro ao cancelar agendamento: $e';
    }
  }

  // Liberar time slot
  Future<void> _releaseTimeSlot(String appointmentId) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('time_slots')
          .where('appointmentId', isEqualTo: appointmentId)
          .get();

      for (final doc in querySnapshot.docs) {
        await doc.reference.update({
          'isAvailable': true,
          'appointmentId': null,
          'updatedAt': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      throw 'Erro ao liberar time slot: $e';
    }
  }

  // Verificar disponibilidade de horário
  Future<bool> isTimeSlotAvailable({
    required DateTime date,
    required String time,
    required int duration,
    required String barberId,
    String? excludeAppointmentId,
  }) async {
    try {
      final startTime = DateTime.parse(
        '${date.toIso8601String().split('T')[0]}T$time',
      );
      final endTime = startTime.add(Duration(minutes: duration));

      // Verificar agendamentos existentes
      final QuerySnapshot querySnapshot = await _firestore
          .collection('appointments')
          .where('barberId', isEqualTo: barberId)
          .where('scheduledDate', isEqualTo: date)
          .where('status', whereIn: ['pending', 'confirmed'])
          .get();

      for (final doc in querySnapshot.docs) {
        final appointment = AppointmentModel.fromJson(
          doc.data() as Map<String, dynamic>,
        );

        // Pular o agendamento atual se estiver editando
        if (excludeAppointmentId != null &&
            appointment.id == excludeAppointmentId) {
          continue;
        }

        final appointmentStart = DateTime.parse(
          '${date.toIso8601String().split('T')[0]}T${appointment.scheduledTime}',
        );
        final appointmentEnd = appointmentStart.add(
          Duration(minutes: appointment.duration),
        );

        // Verificar sobreposição
        if (startTime.isBefore(appointmentEnd) &&
            endTime.isAfter(appointmentStart)) {
          return false;
        }
      }

      return true;
    } catch (e) {
      throw 'Erro ao verificar disponibilidade: $e';
    }
  }

  // Buscar horários disponíveis para um serviço
  Future<List<String>> getAvailableTimeSlots({
    required DateTime date,
    required ServiceModel service,
    required String barberId,
    required String barbershopId,
  }) async {
    try {
      final List<String> availableSlots = [];
      final dayOfWeek = _getDayOfWeek(date);

      // Verificar se o serviço está disponível neste dia
      if (!service.availableDays.contains(dayOfWeek)) {
        return [];
      }

      // Horários padrão se não houver configuração específica
      final List<String> defaultHours = [
        '09:00',
        '09:30',
        '10:00',
        '10:30',
        '11:00',
        '11:30',
        '14:00',
        '14:30',
        '15:00',
        '15:30',
        '16:00',
        '16:30',
        '17:00',
        '17:30',
      ];

      final availableHours = service.availableHours[dayOfWeek] ?? defaultHours;

      for (final time in availableHours) {
        final isAvailable = await isTimeSlotAvailable(
          date: date,
          time: time,
          duration: service.duration,
          barberId: barberId,
        );

        if (isAvailable) {
          availableSlots.add(time);
        }
      }

      return availableSlots;
    } catch (e) {
      throw 'Erro ao buscar horários disponíveis: $e';
    }
  }

  // Obter dia da semana em inglês
  String _getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'monday';
      case 2:
        return 'tuesday';
      case 3:
        return 'wednesday';
      case 4:
        return 'thursday';
      case 5:
        return 'friday';
      case 6:
        return 'saturday';
      case 7:
        return 'sunday';
      default:
        return 'monday';
    }
  }
}
