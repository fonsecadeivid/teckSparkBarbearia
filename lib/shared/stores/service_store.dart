import 'package:mobx/mobx.dart';
import '../models/service_model.dart';
import '../services/service_service.dart';

part 'service_store.g.dart';

class ServiceStore = _ServiceStoreBase with _$ServiceStore;

abstract class _ServiceStoreBase with Store {
  final ServiceService _serviceService = ServiceService();

  @observable
  ObservableList<ServiceModel> services = ObservableList<ServiceModel>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  ServiceModel? selectedService;

  @computed
  bool get hasServices => services.isNotEmpty;

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
  void setSelectedService(ServiceModel? service) {
    selectedService = service;
  }

  @action
  Future<void> createService({
    required String name,
    required String description,
    required double price,
    required int duration,
    required String barbershopId,
    List<String>? availableDays,
    Map<String, List<String>>? availableHours,
  }) async {
    try {
      setLoading(true);
      clearError();

      // Verificar se já existe serviço com este nome
      final exists = await _serviceService.serviceExists(name, barbershopId);
      if (exists) {
        throw 'Já existe um serviço cadastrado com este nome.';
      }

      final newService = await _serviceService.createService(
        name: name,
        description: description,
        price: price,
        duration: duration,
        barbershopId: barbershopId,
        availableDays: availableDays,
        availableHours: availableHours,
      );

      services.insert(0, newService);
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> loadServices(String barbershopId) async {
    try {
      setLoading(true);
      clearError();

      final servicesList = await _serviceService.getActiveServicesByBarbershop(
        barbershopId,
      );
      services.clear();
      services.addAll(servicesList);
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> updateService(ServiceModel service) async {
    try {
      setLoading(true);
      clearError();

      await _serviceService.updateService(service);

      // Atualizar na lista local
      final index = services.indexWhere((s) => s.id == service.id);
      if (index != -1) {
        services[index] = service;
      }
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> deleteService(String serviceId) async {
    try {
      setLoading(true);
      clearError();

      await _serviceService.deleteService(serviceId);

      // Remover da lista local
      services.removeWhere((service) => service.id == serviceId);
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<ServiceModel?> getServiceById(String serviceId) async {
    try {
      return await _serviceService.getServiceById(serviceId);
    } catch (e) {
      setErrorMessage(e.toString());
      return null;
    }
  }

  @action
  void clearServices() {
    services.clear();
  }

  // Buscar serviços por duração
  @computed
  List<ServiceModel> get servicesByDuration {
    final sortedServices = List<ServiceModel>.from(services);
    sortedServices.sort((a, b) => a.duration.compareTo(b.duration));
    return sortedServices;
  }

  // Buscar serviços por preço
  @computed
  List<ServiceModel> get servicesByPrice {
    final sortedServices = List<ServiceModel>.from(services);
    sortedServices.sort((a, b) => a.price.compareTo(b.price));
    return sortedServices;
  }

  // Buscar serviços ativos
  @computed
  List<ServiceModel> get activeServices {
    return services.where((service) => service.isActive).toList();
  }
}

