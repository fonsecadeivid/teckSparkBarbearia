import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream do usuário atual
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuário atual
  User? get currentUser => _auth.currentUser;

  // Criar usuário com email e senha
  Future<UserCredential> createUserWithEmailAndPassword({
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
      // Criar usuário no Firebase Auth
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Criar documento do usuário no Firestore
      final UserModel userModel = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        userType: userType,
        barbershopId: barbershopId,
        cpfCnpj: cpfCnpj,
        address: address,
        barbershopName: barbershopName,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toJson());

      return userCredential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Fazer login com email e senha
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Fazer logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Buscar dados do usuário no Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Erro ao buscar dados do usuário: $e');
      return null;
    }
  }

  // Atualizar dados do usuário
  Future<void> updateUserData(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.id)
          .update(userModel.toJson());
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Atualizar foto do usuário
  Future<void> updateUserPhoto(String uid, String photoUrl) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'photoUrl': photoUrl,
      });
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Tratar erros de autenticação
  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'Usuário não encontrado.';
        case 'wrong-password':
          return 'Senha incorreta.';
        case 'email-already-in-use':
          return 'Este e-mail já está em uso.';
        case 'weak-password':
          return 'A senha é muito fraca.';
        case 'invalid-email':
          return 'E-mail inválido.';
        case 'user-disabled':
          return 'Usuário desabilitado.';
        case 'too-many-requests':
          return 'Muitas tentativas. Tente novamente mais tarde.';
        case 'operation-not-allowed':
          return 'Operação não permitida.';
        default:
          return 'Erro de autenticação: ${error.message}';
      }
    }
    return 'Erro inesperado. Tente novamente.';
  }
}
