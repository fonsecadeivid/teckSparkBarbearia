// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStoreBase, Store {
  Computed<bool>? _$isLoggedInComputed;

  @override
  bool get isLoggedIn => (_$isLoggedInComputed ??= Computed<bool>(
    () => super.isLoggedIn,
    name: '_AuthStoreBase.isLoggedIn',
  )).value;
  Computed<bool>? _$isBarberComputed;

  @override
  bool get isBarber => (_$isBarberComputed ??= Computed<bool>(
    () => super.isBarber,
    name: '_AuthStoreBase.isBarber',
  )).value;
  Computed<bool>? _$isOwnerComputed;

  @override
  bool get isOwner => (_$isOwnerComputed ??= Computed<bool>(
    () => super.isOwner,
    name: '_AuthStoreBase.isOwner',
  )).value;
  Computed<bool>? _$isClientComputed;

  @override
  bool get isClient => (_$isClientComputed ??= Computed<bool>(
    () => super.isClient,
    name: '_AuthStoreBase.isClient',
  )).value;
  Computed<bool>? _$canAccessDashboardComputed;

  @override
  bool get canAccessDashboard =>
      (_$canAccessDashboardComputed ??= Computed<bool>(
        () => super.canAccessDashboard,
        name: '_AuthStoreBase.canAccessDashboard',
      )).value;
  Computed<bool>? _$canManageClientsComputed;

  @override
  bool get canManageClients => (_$canManageClientsComputed ??= Computed<bool>(
    () => super.canManageClients,
    name: '_AuthStoreBase.canManageClients',
  )).value;
  Computed<bool>? _$canManageServicesComputed;

  @override
  bool get canManageServices => (_$canManageServicesComputed ??= Computed<bool>(
    () => super.canManageServices,
    name: '_AuthStoreBase.canManageServices',
  )).value;
  Computed<bool>? _$canManageAppointmentsComputed;

  @override
  bool get canManageAppointments =>
      (_$canManageAppointmentsComputed ??= Computed<bool>(
        () => super.canManageAppointments,
        name: '_AuthStoreBase.canManageAppointments',
      )).value;
  Computed<bool>? _$canManageBarbershopsComputed;

  @override
  bool get canManageBarbershops =>
      (_$canManageBarbershopsComputed ??= Computed<bool>(
        () => super.canManageBarbershops,
        name: '_AuthStoreBase.canManageBarbershops',
      )).value;

  late final _$currentUserAtom = Atom(
    name: '_AuthStoreBase.currentUser',
    context: context,
  );

  @override
  UserModel? get currentUser {
    _$currentUserAtom.reportRead();
    return super.currentUser;
  }

  @override
  set currentUser(UserModel? value) {
    _$currentUserAtom.reportWrite(value, super.currentUser, () {
      super.currentUser = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_AuthStoreBase.isLoading',
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
    name: '_AuthStoreBase.errorMessage',
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

  late final _$isAuthenticatedAtom = Atom(
    name: '_AuthStoreBase.isAuthenticated',
    context: context,
  );

  @override
  bool get isAuthenticated {
    _$isAuthenticatedAtom.reportRead();
    return super.isAuthenticated;
  }

  @override
  set isAuthenticated(bool value) {
    _$isAuthenticatedAtom.reportWrite(value, super.isAuthenticated, () {
      super.isAuthenticated = value;
    });
  }

  late final _$signUpAsyncAction = AsyncAction(
    '_AuthStoreBase.signUp',
    context: context,
  );

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String userType,
    required String barbershopId,
    String? cpfCnpj,
    String? address,
    String? barbershopName,
  }) {
    return _$signUpAsyncAction.run(
      () => super.signUp(
        email: email,
        password: password,
        name: name,
        phone: phone,
        userType: userType,
        barbershopId: barbershopId,
        cpfCnpj: cpfCnpj,
        address: address,
        barbershopName: barbershopName,
      ),
    );
  }

  late final _$signInAsyncAction = AsyncAction(
    '_AuthStoreBase.signIn',
    context: context,
  );

  @override
  Future<void> signIn({required String email, required String password}) {
    return _$signInAsyncAction.run(
      () => super.signIn(email: email, password: password),
    );
  }

  late final _$signOutAsyncAction = AsyncAction(
    '_AuthStoreBase.signOut',
    context: context,
  );

  @override
  Future<void> signOut() {
    return _$signOutAsyncAction.run(() => super.signOut());
  }

  late final _$checkAuthStateAsyncAction = AsyncAction(
    '_AuthStoreBase.checkAuthState',
    context: context,
  );

  @override
  Future<void> checkAuthState() {
    return _$checkAuthStateAsyncAction.run(() => super.checkAuthState());
  }

  late final _$updateUserProfileAsyncAction = AsyncAction(
    '_AuthStoreBase.updateUserProfile',
    context: context,
  );

  @override
  Future<void> updateUserProfile(UserModel updatedUser) {
    return _$updateUserProfileAsyncAction.run(
      () => super.updateUserProfile(updatedUser),
    );
  }

  late final _$_AuthStoreBaseActionController = ActionController(
    name: '_AuthStoreBase',
    context: context,
  );

  @override
  void setCurrentUser(UserModel? user) {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
      name: '_AuthStoreBase.setCurrentUser',
    );
    try {
      return super.setCurrentUser(user);
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool loading) {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
      name: '_AuthStoreBase.setLoading',
    );
    try {
      return super.setLoading(loading);
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setErrorMessage(String? message) {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
      name: '_AuthStoreBase.setErrorMessage',
    );
    try {
      return super.setErrorMessage(message);
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
      name: '_AuthStoreBase.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentUser: ${currentUser},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
isAuthenticated: ${isAuthenticated},
isLoggedIn: ${isLoggedIn},
isBarber: ${isBarber},
isOwner: ${isOwner},
isClient: ${isClient},
canAccessDashboard: ${canAccessDashboard},
canManageClients: ${canManageClients},
canManageServices: ${canManageServices},
canManageAppointments: ${canManageAppointments},
canManageBarbershops: ${canManageBarbershops}
    ''';
  }
}
