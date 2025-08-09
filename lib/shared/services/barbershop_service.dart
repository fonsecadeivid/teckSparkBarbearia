import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/barbershop_model.dart';

class BarbershopService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // Criar nova barbearia
  Future<BarbershopModel> createBarbershop({
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
      final String barbershopId = _uuid.v4();

      final BarbershopModel barbershop = BarbershopModel(
        id: barbershopId,
        name: name,
        description: description,
        address: address,
        phone: phone,
        email: email,
        photoUrl: photoUrl,
        ownerId: ownerId,
        businessHours: businessHours ?? _getDefaultBusinessHours(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('barbershops')
          .doc(barbershopId)
          .set(barbershop.toJson());

      return barbershop;
    } catch (e) {
      throw 'Erro ao criar barbearia: $e';
    }
  }

  // Buscar barbearia por ID
  Future<BarbershopModel?> getBarbershopById(String barbershopId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('barbershops')
          .doc(barbershopId)
          .get();

      if (doc.exists) {
        return BarbershopModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw 'Erro ao buscar barbearia: $e';
    }
  }

  // Buscar barbearias por dono
  Future<List<BarbershopModel>> getBarbershopsByOwner(String ownerId) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('barbershops')
          .where('ownerId', isEqualTo: ownerId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map(
            (doc) =>
                BarbershopModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw 'Erro ao buscar barbearias: $e';
    }
  }

  // Buscar todas as barbearias ativas
  Future<List<BarbershopModel>> getActiveBarbershops() async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('barbershops')
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map(
            (doc) =>
                BarbershopModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw 'Erro ao buscar barbearias ativas: $e';
    }
  }

  // Atualizar barbearia
  Future<void> updateBarbershop(BarbershopModel barbershop) async {
    try {
      final updatedBarbershop = barbershop.copyWith(updatedAt: DateTime.now());

      await _firestore
          .collection('barbershops')
          .doc(barbershop.id)
          .update(updatedBarbershop.toJson());
    } catch (e) {
      throw 'Erro ao atualizar barbearia: $e';
    }
  }

  // Deletar barbearia
  Future<void> deleteBarbershop(String barbershopId) async {
    try {
      await _firestore.collection('barbershops').doc(barbershopId).delete();
    } catch (e) {
      throw 'Erro ao deletar barbearia: $e';
    }
  }

  // Adicionar barbeiro à barbearia
  Future<void> addBarberToBarbershop(
    String barbershopId,
    String barberId,
  ) async {
    try {
      await _firestore.collection('barbershops').doc(barbershopId).update({
        'barberIds': FieldValue.arrayUnion([barberId]),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw 'Erro ao adicionar barbeiro: $e';
    }
  }

  // Remover barbeiro da barbearia
  Future<void> removeBarberFromBarbershop(
    String barbershopId,
    String barberId,
  ) async {
    try {
      await _firestore.collection('barbershops').doc(barbershopId).update({
        'barberIds': FieldValue.arrayRemove([barberId]),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw 'Erro ao remover barbeiro: $e';
    }
  }

  // Adicionar serviço à barbearia
  Future<void> addServiceToBarbershop(
    String barbershopId,
    String serviceId,
  ) async {
    try {
      await _firestore.collection('barbershops').doc(barbershopId).update({
        'serviceIds': FieldValue.arrayUnion([serviceId]),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw 'Erro ao adicionar serviço: $e';
    }
  }

  // Remover serviço da barbearia
  Future<void> removeServiceFromBarbershop(
    String barbershopId,
    String serviceId,
  ) async {
    try {
      await _firestore.collection('barbershops').doc(barbershopId).update({
        'serviceIds': FieldValue.arrayRemove([serviceId]),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw 'Erro ao remover serviço: $e';
    }
  }

  // Verificar se barbearia existe
  Future<bool> barbershopExists(String name, String ownerId) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('barbershops')
          .where('name', isEqualTo: name)
          .where('ownerId', isEqualTo: ownerId)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw 'Erro ao verificar existência da barbearia: $e';
    }
  }

  // Obter horários padrão de funcionamento
  Map<String, dynamic> _getDefaultBusinessHours() {
    return {
      'monday': {'open': '08:00', 'close': '18:00', 'isOpen': true},
      'tuesday': {'open': '08:00', 'close': '18:00', 'isOpen': true},
      'wednesday': {'open': '08:00', 'close': '18:00', 'isOpen': true},
      'thursday': {'open': '08:00', 'close': '18:00', 'isOpen': true},
      'friday': {'open': '08:00', 'close': '18:00', 'isOpen': true},
      'saturday': {'open': '08:00', 'close': '17:00', 'isOpen': true},
      'sunday': {'open': '08:00', 'close': '17:00', 'isOpen': false},
    };
  }
}
