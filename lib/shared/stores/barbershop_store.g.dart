// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barbershop_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BarbershopStore on _BarbershopStoreBase, Store {
  Computed<bool>? _$hasBarbershopsComputed;

  @override
  bool get hasBarbershops => (_$hasBarbershopsComputed ??= Computed<bool>(
    () => super.hasBarbershops,
    name: '_BarbershopStoreBase.hasBarbershops',
  )).value;
  Computed<bool>? _$hasCurrentBarbershopComputed;

  @override
  bool get hasCurrentBarbershop =>
      (_$hasCurrentBarbershopComputed ??= Computed<bool>(
        () => super.hasCurrentBarbershop,
        name: '_BarbershopStoreBase.hasCurrentBarbershop',
      )).value;

  late final _$barbershopsAtom = Atom(
    name: '_BarbershopStoreBase.barbershops',
    context: context,
  );

  @override
  ObservableList<BarbershopModel> get barbershops {
    _$barbershopsAtom.reportRead();
    return super.barbershops;
  }

  @override
  set barbershops(ObservableList<BarbershopModel> value) {
    _$barbershopsAtom.reportWrite(value, super.barbershops, () {
      super.barbershops = value;
    });
  }

  late final _$currentBarbershopAtom = Atom(
    name: '_BarbershopStoreBase.currentBarbershop',
    context: context,
  );

  @override
  BarbershopModel? get currentBarbershop {
    _$currentBarbershopAtom.reportRead();
    return super.currentBarbershop;
  }

  @override
  set currentBarbershop(BarbershopModel? value) {
    _$currentBarbershopAtom.reportWrite(value, super.currentBarbershop, () {
      super.currentBarbershop = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_BarbershopStoreBase.isLoading',
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
    name: '_BarbershopStoreBase.errorMessage',
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

  late final _$createBarbershopAsyncAction = AsyncAction(
    '_BarbershopStoreBase.createBarbershop',
    context: context,
  );

  @override
  Future<void> createBarbershop({
    required String name,
    required String description,
    required String address,
    required String phone,
    required String email,
    required String ownerId,
    String? photoUrl,
    Map<String, dynamic>? businessHours,
  }) {
    return _$createBarbershopAsyncAction.run(
      () => super.createBarbershop(
        name: name,
        description: description,
        address: address,
        phone: phone,
        email: email,
        ownerId: ownerId,
        photoUrl: photoUrl,
        businessHours: businessHours,
      ),
    );
  }

  late final _$loadBarbershopsByOwnerAsyncAction = AsyncAction(
    '_BarbershopStoreBase.loadBarbershopsByOwner',
    context: context,
  );

  @override
  Future<void> loadBarbershopsByOwner(String ownerId) {
    return _$loadBarbershopsByOwnerAsyncAction.run(
      () => super.loadBarbershopsByOwner(ownerId),
    );
  }

  late final _$loadBarbershopByIdAsyncAction = AsyncAction(
    '_BarbershopStoreBase.loadBarbershopById',
    context: context,
  );

  @override
  Future<void> loadBarbershopById(String barbershopId) {
    return _$loadBarbershopByIdAsyncAction.run(
      () => super.loadBarbershopById(barbershopId),
    );
  }

  late final _$loadActiveBarbershopsAsyncAction = AsyncAction(
    '_BarbershopStoreBase.loadActiveBarbershops',
    context: context,
  );

  @override
  Future<void> loadActiveBarbershops() {
    return _$loadActiveBarbershopsAsyncAction.run(
      () => super.loadActiveBarbershops(),
    );
  }

  late final _$updateBarbershopAsyncAction = AsyncAction(
    '_BarbershopStoreBase.updateBarbershop',
    context: context,
  );

  @override
  Future<void> updateBarbershop(BarbershopModel barbershop) {
    return _$updateBarbershopAsyncAction.run(
      () => super.updateBarbershop(barbershop),
    );
  }

  late final _$deleteBarbershopAsyncAction = AsyncAction(
    '_BarbershopStoreBase.deleteBarbershop',
    context: context,
  );

  @override
  Future<void> deleteBarbershop(String barbershopId) {
    return _$deleteBarbershopAsyncAction.run(
      () => super.deleteBarbershop(barbershopId),
    );
  }

  late final _$addBarberToBarbershopAsyncAction = AsyncAction(
    '_BarbershopStoreBase.addBarberToBarbershop',
    context: context,
  );

  @override
  Future<void> addBarberToBarbershop(String barbershopId, String barberId) {
    return _$addBarberToBarbershopAsyncAction.run(
      () => super.addBarberToBarbershop(barbershopId, barberId),
    );
  }

  late final _$removeBarberFromBarbershopAsyncAction = AsyncAction(
    '_BarbershopStoreBase.removeBarberFromBarbershop',
    context: context,
  );

  @override
  Future<void> removeBarberFromBarbershop(
    String barbershopId,
    String barberId,
  ) {
    return _$removeBarberFromBarbershopAsyncAction.run(
      () => super.removeBarberFromBarbershop(barbershopId, barberId),
    );
  }

  late final _$_BarbershopStoreBaseActionController = ActionController(
    name: '_BarbershopStoreBase',
    context: context,
  );

  @override
  void setLoading(bool loading) {
    final _$actionInfo = _$_BarbershopStoreBaseActionController.startAction(
      name: '_BarbershopStoreBase.setLoading',
    );
    try {
      return super.setLoading(loading);
    } finally {
      _$_BarbershopStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setErrorMessage(String? message) {
    final _$actionInfo = _$_BarbershopStoreBaseActionController.startAction(
      name: '_BarbershopStoreBase.setErrorMessage',
    );
    try {
      return super.setErrorMessage(message);
    } finally {
      _$_BarbershopStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_BarbershopStoreBaseActionController.startAction(
      name: '_BarbershopStoreBase.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_BarbershopStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentBarbershop(BarbershopModel? barbershop) {
    final _$actionInfo = _$_BarbershopStoreBaseActionController.startAction(
      name: '_BarbershopStoreBase.setCurrentBarbershop',
    );
    try {
      return super.setCurrentBarbershop(barbershop);
    } finally {
      _$_BarbershopStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
barbershops: ${barbershops},
currentBarbershop: ${currentBarbershop},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
hasBarbershops: ${hasBarbershops},
hasCurrentBarbershop: ${hasCurrentBarbershop}
    ''';
  }
}
