import 'package:mobx/mobx.dart';
import '../models/client_model.dart';
import '../services/client_service.dart';

part 'client_store.g.dart';

class ClientStore = _ClientStoreBase with _$ClientStore;

abstract class _ClientStoreBase with Store {
  final ClientService _clientService = ClientService();

  @observable
  ObservableList<ClientModel> clients = ObservableList<ClientModel>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  ClientModel? selectedClient;

  @computed
  bool get hasClients => clients.isNotEmpty;

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
  void setSelectedClient(ClientModel? client) {
    selectedClient = client;
  }

  @action
  Future<void> createClient({
    required String name,
    required String email,
    required String phone,
    required String barbershopId,
  }) async {
    try {
      setLoading(true);
      clearError();

      // Verificar se já existe cliente com este email
      final existingClientByEmail = await _clientService.getClientByEmail(
        email,
        barbershopId,
      );
      if (existingClientByEmail != null) {
        throw 'Já existe um cliente cadastrado com este e-mail.';
      }

      // Verificar se já existe cliente com este telefone
      final existingClientByPhone = await _clientService.getClientByPhone(
        phone,
        barbershopId,
      );
      if (existingClientByPhone != null) {
        throw 'Já existe um cliente cadastrado com este telefone.';
      }

      final newClient = await _clientService.createClient(
        name: name,
        email: email,
        phone: phone,
        barbershopId: barbershopId,
      );

      clients.insert(0, newClient);
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> loadClients(String barbershopId) async {
    try {
      setLoading(true);
      clearError();

      final clientsList = await _clientService.getClientsByBarbershop(
        barbershopId,
      );
      clients.clear();
      clients.addAll(clientsList);
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> updateClient(ClientModel client) async {
    try {
      setLoading(true);
      clearError();

      await _clientService.updateClient(client);

      // Atualizar na lista local
      final index = clients.indexWhere((c) => c.id == client.id);
      if (index != -1) {
        clients[index] = client;
      }
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> deleteClient(String clientId) async {
    try {
      setLoading(true);
      clearError();

      await _clientService.deleteClient(clientId);

      // Remover da lista local
      clients.removeWhere((client) => client.id == clientId);
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<ClientModel?> getClientById(String clientId) async {
    try {
      return await _clientService.getClientById(clientId);
    } catch (e) {
      setErrorMessage(e.toString());
      return null;
    }
  }

  @action
  void clearClients() {
    clients.clear();
  }
}

