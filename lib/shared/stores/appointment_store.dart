import 'package:mobx/mobx.dart';
import '../models/appointment_model.dart';
import '../models/service_model.dart';
import '../services/appointment_service.dart';

part 'appointment_store.g.dart';

class AppointmentStore = _AppointmentStoreBase with _$AppointmentStore;

abstract class _AppointmentStoreBase with Store {
  final AppointmentService _appointmentService = AppointmentService();

  @observable
  ObservableList<AppointmentModel> appointments =
      ObservableList<AppointmentModel>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  AppointmentModel? selectedAppointment;

  @observable
  List<String> availableTimeSlots = [];

  @computed
  bool get hasAppointments => appointments.isNotEmpty;

  @computed
  List<AppointmentModel> get todayAppointments {
    return appointments.where((appointment) => appointment.isToday).toList();
  }

  @computed
  List<AppointmentModel> get futureAppointments {
    return appointments.where((appointment) => appointment.isFuture).toList();
  }

  @computed
  List<AppointmentModel> get pendingAppointments {
    return appointments
        .where((appointment) => appointment.status == AppointmentStatus.pending)
        .toList();
  }

  @computed
  List<AppointmentModel> get confirmedAppointments {
    return appointments
        .where(
          (appointment) => appointment.status == AppointmentStatus.confirmed,
        )
        .toList();
  }

  @action
  void setLoading(bool loading) {
    isLoading = loading;
  }

  @action
  void setErrorMessage(String? message) {
    errorMessage = message;
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @action
  void setSelectedAppointment(AppointmentModel? appointment) {
    selectedAppointment = appointment;
  }

  @action
  void setAvailableTimeSlots(List<String> timeSlots) {
    availableTimeSlots = timeSlots;
  }

  @action
  Future<void> createAppointment({
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
      setLoading(true);
      clearError();

      final newAppointment = await _appointmentService.createAppointment(
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
      );

      appointments.insert(0, newAppointment);
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> loadAppointmentsByBarbershop(String barbershopId) async {
    try {
      setLoading(true);
      clearError();

      final appointmentsList = await _appointmentService
          .getAppointmentsByBarbershop(barbershopId);
      appointments.clear();
      appointments.addAll(appointmentsList);
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> loadAppointmentsByClient(String clientId) async {
    try {
      setLoading(true);
      clearError();

      final appointmentsList = await _appointmentService
          .getAppointmentsByClient(clientId);
      appointments.clear();
      appointments.addAll(appointmentsList);
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> loadAppointmentsByBarber(String barberId) async {
    try {
      setLoading(true);
      clearError();

      final appointmentsList = await _appointmentService
          .getAppointmentsByBarber(barberId);
      appointments.clear();
      appointments.addAll(appointmentsList);
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> loadAppointmentsByDate(
    DateTime date,
    String barbershopId,
  ) async {
    try {
      setLoading(true);
      clearError();

      final appointmentsList = await _appointmentService.getAppointmentsByDate(
        date,
        barbershopId,
      );
      appointments.clear();
      appointments.addAll(appointmentsList);
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> updateAppointment(AppointmentModel appointment) async {
    try {
      setLoading(true);
      clearError();

      await _appointmentService.updateAppointment(appointment);

      // Atualizar na lista local
      final index = appointments.indexWhere((a) => a.id == appointment.id);
      if (index != -1) {
        appointments[index] = appointment;
      }
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      setLoading(true);
      clearError();

      await _appointmentService.cancelAppointment(appointmentId);

      // Atualizar na lista local
      final index = appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        final appointment = appointments[index];
        appointments[index] = appointment.copyWith(
          status: AppointmentStatus.cancelled,
        );
      }
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> confirmAppointment(String appointmentId) async {
    try {
      setLoading(true);
      clearError();

      final appointment = appointments.firstWhere((a) => a.id == appointmentId);
      final updatedAppointment = appointment.copyWith(
        status: AppointmentStatus.confirmed,
      );

      await _appointmentService.updateAppointment(updatedAppointment);

      // Atualizar na lista local
      final index = appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        appointments[index] = updatedAppointment;
      }
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> completeAppointment(String appointmentId) async {
    try {
      setLoading(true);
      clearError();

      final appointment = appointments.firstWhere((a) => a.id == appointmentId);
      final updatedAppointment = appointment.copyWith(
        status: AppointmentStatus.completed,
      );

      await _appointmentService.updateAppointment(updatedAppointment);

      // Atualizar na lista local
      final index = appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        appointments[index] = updatedAppointment;
      }
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<List<String>> getAvailableTimeSlots({
    required DateTime date,
    required ServiceModel service,
    required String barberId,
    required String barbershopId,
  }) async {
    try {
      final timeSlots = await _appointmentService.getAvailableTimeSlots(
        date: date,
        service: service,
        barberId: barberId,
        barbershopId: barbershopId,
      );

      setAvailableTimeSlots(timeSlots);
      return timeSlots;
    } catch (e) {
      setErrorMessage(e.toString());
      return [];
    }
  }

  @action
  Future<bool> isTimeSlotAvailable({
    required DateTime date,
    required String time,
    required int duration,
    required String barberId,
    String? excludeAppointmentId,
  }) async {
    try {
      return await _appointmentService.isTimeSlotAvailable(
        date: date,
        time: time,
        duration: duration,
        barberId: barberId,
        excludeAppointmentId: excludeAppointmentId,
      );
    } catch (e) {
      setErrorMessage(e.toString());
      return false;
    }
  }

  @action
  void clearAppointments() {
    appointments.clear();
  }

  @action
  void clearAvailableTimeSlots() {
    availableTimeSlots.clear();
  }
}
