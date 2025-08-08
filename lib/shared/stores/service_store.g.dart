// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ServiceStore on _ServiceStoreBase, Store {
  Computed<bool>? _$hasServicesComputed;

  @override
  bool get hasServices => (_$hasServicesComputed ??= Computed<bool>(
    () => super.hasServices,
    name: '_ServiceStoreBase.hasServices',
  )).value;
  Computed<List<ServiceModel>>? _$servicesByDurationComputed;

  @override
  List<ServiceModel> get servicesByDuration =>
      (_$servicesByDurationComputed ??= Computed<List<ServiceModel>>(
        () => super.servicesByDuration,
        name: '_ServiceStoreBase.servicesByDuration',
      )).value;
  Computed<List<ServiceModel>>? _$servicesByPriceComputed;

  @override
  List<ServiceModel> get servicesByPrice =>
      (_$servicesByPriceComputed ??= Computed<List<ServiceModel>>(
        () => super.servicesByPrice,
        name: '_ServiceStoreBase.servicesByPrice',
      )).value;
  Computed<List<ServiceModel>>? _$activeServicesComputed;

  @override
  List<ServiceModel> get activeServices =>
      (_$activeServicesComputed ??= Computed<List<ServiceModel>>(
        () => super.activeServices,
        name: '_ServiceStoreBase.activeServices',
      )).value;

  late final _$servicesAtom = Atom(
    name: '_ServiceStoreBase.services',
    context: context,
  );

  @override
  ObservableList<ServiceModel> get services {
    _$servicesAtom.reportRead();
    return super.services;
  }

  @override
  set services(ObservableList<ServiceModel> value) {
    _$servicesAtom.reportWrite(value, super.services, () {
      super.services = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_ServiceStoreBase.isLoading',
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
    name: '_ServiceStoreBase.errorMessage',
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

  late final _$selectedServiceAtom = Atom(
    name: '_ServiceStoreBase.selectedService',
    context: context,
  );

  @override
  ServiceModel? get selectedService {
    _$selectedServiceAtom.reportRead();
    return super.selectedService;
  }

  @override
  set selectedService(ServiceModel? value) {
    _$selectedServiceAtom.reportWrite(value, super.selectedService, () {
      super.selectedService = value;
    });
  }

  late final _$createServiceAsyncAction = AsyncAction(
    '_ServiceStoreBase.createService',
    context: context,
  );

  @override
  Future<void> createService({
    required String name,
    required String description,
    required double price,
    required int duration,
    required String barbershopId,
    List<String>? availableDays,
    Map<String, List<String>>? availableHours,
  }) {
    return _$createServiceAsyncAction.run(
      () => super.createService(
        name: name,
        description: description,
        price: price,
        duration: duration,
        barbershopId: barbershopId,
        availableDays: availableDays,
        availableHours: availableHours,
      ),
    );
  }

  late final _$loadServicesAsyncAction = AsyncAction(
    '_ServiceStoreBase.loadServices',
    context: context,
  );

  @override
  Future<void> loadServices(String barbershopId) {
    return _$loadServicesAsyncAction.run(
      () => super.loadServices(barbershopId),
    );
  }

  late final _$updateServiceAsyncAction = AsyncAction(
    '_ServiceStoreBase.updateService',
    context: context,
  );

  @override
  Future<void> updateService(ServiceModel service) {
    return _$updateServiceAsyncAction.run(() => super.updateService(service));
  }

  late final _$deleteServiceAsyncAction = AsyncAction(
    '_ServiceStoreBase.deleteService',
    context: context,
  );

  @override
  Future<void> deleteService(String serviceId) {
    return _$deleteServiceAsyncAction.run(() => super.deleteService(serviceId));
  }

  late final _$getServiceByIdAsyncAction = AsyncAction(
    '_ServiceStoreBase.getServiceById',
    context: context,
  );

  @override
  Future<ServiceModel?> getServiceById(String serviceId) {
    return _$getServiceByIdAsyncAction.run(
      () => super.getServiceById(serviceId),
    );
  }

  late final _$_ServiceStoreBaseActionController = ActionController(
    name: '_ServiceStoreBase',
    context: context,
  );

  @override
  void setLoading(bool loading) {
    final _$actionInfo = _$_ServiceStoreBaseActionController.startAction(
      name: '_ServiceStoreBase.setLoading',
    );
    try {
      return super.setLoading(loading);
    } finally {
      _$_ServiceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setErrorMessage(String? message) {
    final _$actionInfo = _$_ServiceStoreBaseActionController.startAction(
      name: '_ServiceStoreBase.setErrorMessage',
    );
    try {
      return super.setErrorMessage(message);
    } finally {
      _$_ServiceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_ServiceStoreBaseActionController.startAction(
      name: '_ServiceStoreBase.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_ServiceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedService(ServiceModel? service) {
    final _$actionInfo = _$_ServiceStoreBaseActionController.startAction(
      name: '_ServiceStoreBase.setSelectedService',
    );
    try {
      return super.setSelectedService(service);
    } finally {
      _$_ServiceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearServices() {
    final _$actionInfo = _$_ServiceStoreBaseActionController.startAction(
      name: '_ServiceStoreBase.clearServices',
    );
    try {
      return super.clearServices();
    } finally {
      _$_ServiceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
services: ${services},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
selectedService: ${selectedService},
hasServices: ${hasServices},
servicesByDuration: ${servicesByDuration},
servicesByPrice: ${servicesByPrice},
activeServices: ${activeServices}
    ''';
  }
}
