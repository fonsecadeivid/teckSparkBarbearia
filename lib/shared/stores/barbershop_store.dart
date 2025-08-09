import 'package:mobx/mobx.dart';
import '../models/barbershop_model.dart';
import '../services/barbershop_service.dart';

part 'barbershop_store.g.dart';

class BarbershopStore = _BarbershopStoreBase with _$BarbershopStore;

abstract class _BarbershopStoreBase with Store {
  final BarbershopService _barbershopService = BarbershopService();

  @observable
  ObservableList<BarbershopModel> barbershops =
      ObservableList<BarbershopModel>();

  @observable
  BarbershopModel? currentBarbershop;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @computed
  bool get hasBarbershops => barbershops.isNotEmpty;

  @computed
  bool get hasCurrentBarbershop => currentBarbershop != null;

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
  void setCurrentBarbershop(BarbershopModel? barbershop) {
    currentBarbershop = barbershop;
  }

  @action
  Future<void> createBarbershop({
    required String name,
    required String description,
    required String address,
    required String phone,
    required String email,
    required String ownerId,
    String? photoUrl,
    Map<String, dynamic>? businessHours,
  }) async {
    try {
      setLoading(true);
      clearError();

      // Verificar se já existe barbearia com este nome
      final exists = await _barbershopService.barbershopExists(name, ownerId);
      if (exists) {
        throw 'Já existe uma barbearia cadastrada com este nome.';
      }

      final newBarbershop = await _barbershopService.createBarbershop(
        name: name,
        description: description,
        address: address,
        phone: phone,
        email: email,
        ownerId: ownerId,
        photoUrl: photoUrl,
        businessHours: businessHours,
      );

      barbershops.insert(0, newBarbershop);
      setCurrentBarbershop(newBarbershop);
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> loadBarbershopsByOwner(String ownerId) async {
    try {
      setLoading(true);
      clearError();

      final barbershopsList = await _barbershopService.getBarbershopsByOwner(
        ownerId,
      );
      barbershops.clear();
      barbershops.addAll(barbershopsList);

      // Se há barbearias, definir a primeira como atual
      if (barbershops.isNotEmpty && currentBarbershop == null) {
        setCurrentBarbershop(barbershops.first);
      }
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> loadBarbershopById(String barbershopId) async {
    try {
      setLoading(true);
      clearError();

      final barbershop = await _barbershopService.getBarbershopById(
        barbershopId,
      );
      if (barbershop != null) {
        setCurrentBarbershop(barbershop);
      } else {
        throw 'Barbearia não encontrada.';
      }
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> loadActiveBarbershops() async {
    try {
      setLoading(true);
      clearError();

      final barbershopsList = await _barbershopService.getActiveBarbershops();
      barbershops.clear();
      barbershops.addAll(barbershopsList);
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> updateBarbershop(BarbershopModel barbershop) async {
    try {
      setLoading(true);
      clearError();

      await _barbershopService.updateBarbershop(barbershop);

      // Atualizar na lista local
      final index = barbershops.indexWhere((b) => b.id == barbershop.id);
      if (index != -1) {
        barbershops[index] = barbershop;
      }

      // Atualizar barbearia atual se necessário
      if (currentBarbershop?.id == barbershop.id) {
        setCurrentBarbershop(barbershop);
      }
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> deleteBarbershop(String barbershopId) async {
    try {
      setLoading(true);
      clearError();

      await _barbershopService.deleteBarbershop(barbershopId);

      // Remover da lista local
      barbershops.removeWhere((b) => b.id == barbershopId);

      // Limpar barbearia atual se necessário
      if (currentBarbershop?.id == barbershopId) {
        setCurrentBarbershop(null);
      }
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> addBarberToBarbershop(
    String barbershopId,
    String barberId,
  ) async {
    try {
      setLoading(true);
      clearError();

      await _barbershopService.addBarberToBarbershop(barbershopId, barberId);

      // Atualizar barbearia local
      final index = barbershops.indexWhere((b) => b.id == barbershopId);
      if (index != -1) {
        final updatedBarbershop = barbershops[index].copyWith(
          barberIds: [...barbershops[index].barberIds, barberId],
        );
        barbershops[index] = updatedBarbershop;

        if (currentBarbershop?.id == barbershopId) {
          setCurrentBarbershop(updatedBarbershop);
        }
      }
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> removeBarberFromBarbershop(
    String barbershopId,
    String barberId,
  ) async {
    try {
      setLoading(true);
      clearError();

      await _barbershopService.removeBarberFromBarbershop(
        barbershopId,
        barberId,
      );

      // Atualizar barbearia local
      final index = barbershops.indexWhere((b) => b.id == barbershopId);
      if (index != -1) {
        final updatedBarbershop = barbershops[index].copyWith(
          barberIds: barbershops[index].barberIds
              .where((id) => id != barberId)
              .toList(),
        );
        barbershops[index] = updatedBarbershop;

        if (currentBarbershop?.id == barbershopId) {
          setCurrentBarbershop(updatedBarbershop);
        }
      }
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
