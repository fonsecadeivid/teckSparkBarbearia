// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ClientStore on _ClientStoreBase, Store {
  Computed<bool>? _$hasClientsComputed;

  @override
  bool get hasClients => (_$hasClientsComputed ??= Computed<bool>(
    () => super.hasClients,
    name: '_ClientStoreBase.hasClients',
  )).value;

  late final _$clientsAtom = Atom(
    name: '_ClientStoreBase.clients',
    context: context,
  );

  @override
  ObservableList<ClientModel> get clients {
    _$clientsAtom.reportRead();
    return super.clients;
  }

  @override
  set clients(ObservableList<ClientModel> value) {
    _$clientsAtom.reportWrite(value, super.clients, () {
      super.clients = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_ClientStoreBase.isLoading',
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
    name: '_ClientStoreBase.errorMessage',
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

  late final _$selectedClientAtom = Atom(
    name: '_ClientStoreBase.selectedClient',
    context: context,
  );

  @override
  ClientModel? get selectedClient {
    _$selectedClientAtom.reportRead();
    return super.selectedClient;
  }

  @override
  set selectedClient(ClientModel? value) {
    _$selectedClientAtom.reportWrite(value, super.selectedClient, () {
      super.selectedClient = value;
    });
  }

  late final _$createClientAsyncAction = AsyncAction(
    '_ClientStoreBase.createClient',
    context: context,
  );

  @override
  Future<void> createClient({
    required String name,
    required String email,
    required String phone,
    required String barbershopId,
  }) {
    return _$createClientAsyncAction.run(
      () => super.createClient(
        name: name,
        email: email,
        phone: phone,
        barbershopId: barbershopId,
      ),
    );
  }

  late final _$loadClientsAsyncAction = AsyncAction(
    '_ClientStoreBase.loadClients',
    context: context,
  );

  @override
  Future<void> loadClients(String barbershopId) {
    return _$loadClientsAsyncAction.run(() => super.loadClients(barbershopId));
  }

  late final _$updateClientAsyncAction = AsyncAction(
    '_ClientStoreBase.updateClient',
    context: context,
  );

  @override
  Future<void> updateClient(ClientModel client) {
    return _$updateClientAsyncAction.run(() => super.updateClient(client));
  }

  late final _$deleteClientAsyncAction = AsyncAction(
    '_ClientStoreBase.deleteClient',
    context: context,
  );

  @override
  Future<void> deleteClient(String clientId) {
    return _$deleteClientAsyncAction.run(() => super.deleteClient(clientId));
  }

  late final _$getClientByIdAsyncAction = AsyncAction(
    '_ClientStoreBase.getClientById',
    context: context,
  );

  @override
  Future<ClientModel?> getClientById(String clientId) {
    return _$getClientByIdAsyncAction.run(() => super.getClientById(clientId));
  }

  late final _$_ClientStoreBaseActionController = ActionController(
    name: '_ClientStoreBase',
    context: context,
  );

  @override
  void setLoading(bool loading) {
    final _$actionInfo = _$_ClientStoreBaseActionController.startAction(
      name: '_ClientStoreBase.setLoading',
    );
    try {
      return super.setLoading(loading);
    } finally {
      _$_ClientStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setErrorMessage(String? message) {
    final _$actionInfo = _$_ClientStoreBaseActionController.startAction(
      name: '_ClientStoreBase.setErrorMessage',
    );
    try {
      return super.setErrorMessage(message);
    } finally {
      _$_ClientStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_ClientStoreBaseActionController.startAction(
      name: '_ClientStoreBase.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_ClientStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedClient(ClientModel? client) {
    final _$actionInfo = _$_ClientStoreBaseActionController.startAction(
      name: '_ClientStoreBase.setSelectedClient',
    );
    try {
      return super.setSelectedClient(client);
    } finally {
      _$_ClientStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearClients() {
    final _$actionInfo = _$_ClientStoreBaseActionController.startAction(
      name: '_ClientStoreBase.clearClients',
    );
    try {
      return super.clearClients();
    } finally {
      _$_ClientStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
clients: ${clients},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
selectedClient: ${selectedClient},
hasClients: ${hasClients}
    ''';
  }
}
