import 'package:mobx/mobx.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../../core/constants/user_types.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  final AuthService _authService = AuthService();

  @observable
  UserModel? currentUser;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  bool isAuthenticated = false;

  @computed
  bool get isLoggedIn => currentUser != null && isAuthenticated;

  @computed
  bool get isBarber =>
      currentUser != null && UserTypes.isBarber(currentUser!.userType);

  @computed
  bool get isOwner =>
      currentUser != null && UserTypes.isOwner(currentUser!.userType);

  @computed
  bool get isClient =>
      currentUser != null && UserTypes.isClient(currentUser!.userType);

  @computed
  bool get canAccessDashboard => isOwner;

  @computed
  bool get canManageClients => isBarber;

  @computed
  bool get canManageServices => isBarber;

  @computed
  bool get canManageAppointments => isBarber;

  @computed
  bool get canManageBarbershops => isOwner;

  @action
  void setCurrentUser(UserModel? user) {
    currentUser = user;
    isAuthenticated = user != null;
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
  }) async {
    try {
      setLoading(true);
      clearError();

      await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        phone: phone,
        userType: userType,
        barbershopId: barbershopId,
        cpfCnpj: cpfCnpj,
        address: address,
        barbershopName: barbershopName,
      );

      // Buscar dados do usuário criado
      final userData = await _authService.getUserData(
        _authService.currentUser!.uid,
      );

      if (userData != null) {
        setCurrentUser(userData);
      }
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> signIn({required String email, required String password}) async {
    try {
      setLoading(true);
      clearError();

      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Buscar dados do usuário
      final userData = await _authService.getUserData(
        _authService.currentUser!.uid,
      );
      if (userData != null) {
        setCurrentUser(userData);
      }
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> signOut() async {
    try {
      setLoading(true);
      await _authService.signOut();
      setCurrentUser(null);
      clearError();
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> checkAuthState() async {
    try {
      final user = _authService.currentUser;
      if (user != null) {
        final userData = await _authService.getUserData(user.uid);
        if (userData != null) {
          setCurrentUser(userData);
        }
      }
    } catch (e) {
      print('Erro ao verificar estado de autenticação: $e');
    }
  }

  @action
  Future<void> updateUserProfile(UserModel updatedUser) async {
    try {
      setLoading(true);
      await _authService.updateUserData(updatedUser);
      setCurrentUser(updatedUser);
    } catch (e) {
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
