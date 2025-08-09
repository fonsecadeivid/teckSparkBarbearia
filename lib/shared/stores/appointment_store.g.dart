// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppointmentStore on _AppointmentStoreBase, Store {
  Computed<bool>? _$hasAppointmentsComputed;

  @override
  bool get hasAppointments => (_$hasAppointmentsComputed ??= Computed<bool>(
    () => super.hasAppointments,
    name: '_AppointmentStoreBase.hasAppointments',
  )).value;
  Computed<List<AppointmentModel>>? _$todayAppointmentsComputed;

  @override
  List<AppointmentModel> get todayAppointments =>
      (_$todayAppointmentsComputed ??= Computed<List<AppointmentModel>>(
        () => super.todayAppointments,
        name: '_AppointmentStoreBase.todayAppointments',
      )).value;
  Computed<List<AppointmentModel>>? _$futureAppointmentsComputed;

  @override
  List<AppointmentModel> get futureAppointments =>
      (_$futureAppointmentsComputed ??= Computed<List<AppointmentModel>>(
        () => super.futureAppointments,
        name: '_AppointmentStoreBase.futureAppointments',
      )).value;
  Computed<List<AppointmentModel>>? _$pendingAppointmentsComputed;

  @override
  List<AppointmentModel> get pendingAppointments =>
      (_$pendingAppointmentsComputed ??= Computed<List<AppointmentModel>>(
        () => super.pendingAppointments,
        name: '_AppointmentStoreBase.pendingAppointments',
      )).value;
  Computed<List<AppointmentModel>>? _$confirmedAppointmentsComputed;

  @override
  List<AppointmentModel> get confirmedAppointments =>
      (_$confirmedAppointmentsComputed ??= Computed<List<AppointmentModel>>(
        () => super.confirmedAppointments,
        name: '_AppointmentStoreBase.confirmedAppointments',
      )).value;

  late final _$appointmentsAtom = Atom(
    name: '_AppointmentStoreBase.appointments',
    context: context,
  );

  @override
  ObservableList<AppointmentModel> get appointments {
    _$appointmentsAtom.reportRead();
    return super.appointments;
  }

  @override
  set appointments(ObservableList<AppointmentModel> value) {
    _$appointmentsAtom.reportWrite(value, super.appointments, () {
      super.appointments = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_AppointmentStoreBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_AppointmentStoreBase.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$selectedAppointmentAtom = Atom(
    name: '_AppointmentStoreBase.selectedAppointment',
    context: context,
  );

  @override
  AppointmentModel? get selectedAppointment {
    _$selectedAppointmentAtom.reportRead();
    return super.selectedAppointment;
  }

  @override
  set selectedAppointment(AppointmentModel? value) {
    _$selectedAppointmentAtom.reportWrite(value, super.selectedAppointment, () {
      super.selectedAppointment = value;
    });
  }

  late final _$availableTimeSlotsAtom = Atom(
    name: '_AppointmentStoreBase.availableTimeSlots',
    context: context,
  );

  @override
  List<String> get availableTimeSlots {
    _$availableTimeSlotsAtom.reportRead();
    return super.availableTimeSlots;
  }

  @override
  set availableTimeSlots(List<String> value) {
    _$availableTimeSlotsAtom.reportWrite(value, super.availableTimeSlots, () {
      super.availableTimeSlots = value;
    });
  }

  late final _$createAppointmentAsyncAction = AsyncAction(
    '_AppointmentStoreBase.createAppointment',
    context: context,
  );

  @override
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
  }) {
    return _$createAppointmentAsyncAction.run(
      () => super.createAppointment(
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
      ),
    );
  }

  late final _$loadAppointmentsAsyncAction = AsyncAction(
    '_AppointmentStoreBase.loadAppointments',
    context: context,
  );

  @override
  Future<void> loadAppointments(String barbershopId) {
    return _$loadAppointmentsAsyncAction.run(
      () => super.loadAppointments(barbershopId),
    );
  }

  late final _$loadAppointmentsByBarbershopAsyncAction = AsyncAction(
    '_AppointmentStoreBase.loadAppointmentsByBarbershop',
    context: context,
  );

  @override
  Future<void> loadAppointmentsByBarbershop(String barbershopId) {
    return _$loadAppointmentsByBarbershopAsyncAction.run(
      () => super.loadAppointmentsByBarbershop(barbershopId),
    );
  }

  late final _$loadAppointmentsByClientAsyncAction = AsyncAction(
    '_AppointmentStoreBase.loadAppointmentsByClient',
    context: context,
  );

  @override
  Future<void> loadAppointmentsByClient(String clientId) {
    return _$loadAppointmentsByClientAsyncAction.run(
      () => super.loadAppointmentsByClient(clientId),
    );
  }

  late final _$loadAppointmentsByBarberAsyncAction = AsyncAction(
    '_AppointmentStoreBase.loadAppointmentsByBarber',
    context: context,
  );

  @override
  Future<void> loadAppointmentsByBarber(String barberId) {
    return _$loadAppointmentsByBarberAsyncAction.run(
      () => super.loadAppointmentsByBarber(barberId),
    );
  }

  late final _$loadAppointmentsByDateAsyncAction = AsyncAction(
    '_AppointmentStoreBase.loadAppointmentsByDate',
    context: context,
  );

  @override
  Future<void> loadAppointmentsByDate(DateTime date, String barbershopId) {
    return _$loadAppointmentsByDateAsyncAction.run(
      () => super.loadAppointmentsByDate(date, barbershopId),
    );
  }

  late final _$updateAppointmentAsyncAction = AsyncAction(
    '_AppointmentStoreBase.updateAppointment',
    context: context,
  );

  @override
  Future<void> updateAppointment(AppointmentModel appointment) {
    return _$updateAppointmentAsyncAction.run(
      () => super.updateAppointment(appointment),
    );
  }

  late final _$cancelAppointmentAsyncAction = AsyncAction(
    '_AppointmentStoreBase.cancelAppointment',
    context: context,
  );

  @override
  Future<void> cancelAppointment(String appointmentId) {
    return _$cancelAppointmentAsyncAction.run(
      () => super.cancelAppointment(appointmentId),
    );
  }

  late final _$confirmAppointmentAsyncAction = AsyncAction(
    '_AppointmentStoreBase.confirmAppointment',
    context: context,
  );

  @override
  Future<void> confirmAppointment(String appointmentId) {
    return _$confirmAppointmentAsyncAction.run(
      () => super.confirmAppointment(appointmentId),
    );
  }

  late final _$completeAppointmentAsyncAction = AsyncAction(
    '_AppointmentStoreBase.completeAppointment',
    context: context,
  );

  @override
  Future<void> completeAppointment(String appointmentId) {
    return _$completeAppointmentAsyncAction.run(
      () => super.completeAppointment(appointmentId),
    );
  }

  late final _$getAvailableTimeSlotsAsyncAction = AsyncAction(
    '_AppointmentStoreBase.getAvailableTimeSlots',
    context: context,
  );

  @override
  Future<List<String>> getAvailableTimeSlots({
    required DateTime date,
    required ServiceModel service,
    required String barberId,
    required String barbershopId,
  }) {
    return _$getAvailableTimeSlotsAsyncAction.run(
      () => super.getAvailableTimeSlots(
        date: date,
        service: service,
        barberId: barberId,
        barbershopId: barbershopId,
      ),
    );
  }

  late final _$isTimeSlotAvailableAsyncAction = AsyncAction(
    '_AppointmentStoreBase.isTimeSlotAvailable',
    context: context,
  );

  @override
  Future<bool> isTimeSlotAvailable({
    required DateTime date,
    required String time,
    required int duration,
    required String barberId,
    String? excludeAppointmentId,
  }) {
    return _$isTimeSlotAvailableAsyncAction.run(
      () => super.isTimeSlotAvailable(
        date: date,
        time: time,
        duration: duration,
        barberId: barberId,
        excludeAppointmentId: excludeAppointmentId,
      ),
    );
  }

  late final _$_AppointmentStoreBaseActionController = ActionController(
    name: '_AppointmentStoreBase',
    context: context,
  );

  @override
  void setLoading(bool loading) {
    final _$actionInfo = _$_AppointmentStoreBaseActionController.startAction(
      name: '_AppointmentStoreBase.setLoading',
    );
    try {
      return super.setLoading(loading);
    } finally {
      _$_AppointmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setErrorMessage(String? message) {
    final _$actionInfo = _$_AppointmentStoreBaseActionController.startAction(
      name: '_AppointmentStoreBase.setErrorMessage',
    );
    try {
      return super.setErrorMessage(message);
    } finally {
      _$_AppointmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_AppointmentStoreBaseActionController.startAction(
      name: '_AppointmentStoreBase.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_AppointmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedAppointment(AppointmentModel? appointment) {
    final _$actionInfo = _$_AppointmentStoreBaseActionController.startAction(
      name: '_AppointmentStoreBase.setSelectedAppointment',
    );
    try {
      return super.setSelectedAppointment(appointment);
    } finally {
      _$_AppointmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAvailableTimeSlots(List<String> timeSlots) {
    final _$actionInfo = _$_AppointmentStoreBaseActionController.startAction(
      name: '_AppointmentStoreBase.setAvailableTimeSlots',
    );
    try {
      return super.setAvailableTimeSlots(timeSlots);
    } finally {
      _$_AppointmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearAppointments() {
    final _$actionInfo = _$_AppointmentStoreBaseActionController.startAction(
      name: '_AppointmentStoreBase.clearAppointments',
    );
    try {
      return super.clearAppointments();
    } finally {
      _$_AppointmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearAvailableTimeSlots() {
    final _$actionInfo = _$_AppointmentStoreBaseActionController.startAction(
      name: '_AppointmentStoreBase.clearAvailableTimeSlots',
    );
    try {
      return super.clearAvailableTimeSlots();
    } finally {
      _$_AppointmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
appointments: ${appointments},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
selectedAppointment: ${selectedAppointment},
availableTimeSlots: ${availableTimeSlots},
hasAppointments: ${hasAppointments},
todayAppointments: ${todayAppointments},
futureAppointments: ${futureAppointments},
pendingAppointments: ${pendingAppointments},
confirmedAppointments: ${confirmedAppointments}
    ''';
  }
}
