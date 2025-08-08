import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/client_model.dart';

class ClientService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // Criar novo cliente
  Future<ClientModel> createClient({
    required String name,
    required String email,
    required String phone,
    required String barbershopId,
  }) async {
    try {
      final String clientId = _uuid.v4();

      final ClientModel client = ClientModel(
        id: clientId,
        name: name,
        email: email,
        phone: phone,
        barbershopId: barbershopId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('clients').doc(clientId).set(client.toJson());

      return client;
    } catch (e) {
      throw 'Erro ao criar cliente: $e';
    }
  }

  // Buscar cliente por ID
  Future<ClientModel?> getClientById(String clientId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('clients')
          .doc(clientId)
          .get();

      if (doc.exists) {
        return ClientModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw 'Erro ao buscar cliente: $e';
    }
  }

  // Buscar clientes por barbearia
  Future<List<ClientModel>> getClientsByBarbershop(String barbershopId) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('clients')
          .where('barbershopId', isEqualTo: barbershopId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map(
            (doc) => ClientModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw 'Erro ao buscar clientes: $e';
    }
  }

  // Atualizar cliente
  Future<void> updateClient(ClientModel client) async {
    try {
      final updatedClient = client.copyWith(updatedAt: DateTime.now());

      await _firestore
          .collection('clients')
          .doc(client.id)
          .update(updatedClient.toJson());
    } catch (e) {
      throw 'Erro ao atualizar cliente: $e';
    }
  }

  // Deletar cliente
  Future<void> deleteClient(String clientId) async {
    try {
      await _firestore.collection('clients').doc(clientId).delete();
    } catch (e) {
      throw 'Erro ao deletar cliente: $e';
    }
  }

  // Buscar cliente por email
  Future<ClientModel?> getClientByEmail(
    String email,
    String barbershopId,
  ) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('clients')
          .where('email', isEqualTo: email)
          .where('barbershopId', isEqualTo: barbershopId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return ClientModel.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      throw 'Erro ao buscar cliente por email: $e';
    }
  }

  // Buscar cliente por telefone
  Future<ClientModel?> getClientByPhone(
    String phone,
    String barbershopId,
  ) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('clients')
          .where('phone', isEqualTo: phone)
          .where('barbershopId', isEqualTo: barbershopId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return ClientModel.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      throw 'Erro ao buscar cliente por telefone: $e';
    }
  }
}

