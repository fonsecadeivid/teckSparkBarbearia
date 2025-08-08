import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/service_model.dart';

class ServiceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // Criar novo serviço
  Future<ServiceModel> createService({
    required String name,
    required String description,
    required double price,
    required int duration,
    required String barbershopId,
    List<String>? availableDays,
    Map<String, List<String>>? availableHours,
  }) async {
    try {
      final String serviceId = _uuid.v4();

      final ServiceModel service = ServiceModel(
        id: serviceId,
        name: name,
        description: description,
        price: price,
        duration: duration,
        barbershopId: barbershopId,
        availableDays:
            availableDays ??
            [
              'monday',
              'tuesday',
              'wednesday',
              'thursday',
              'friday',
              'saturday',
            ],
        availableHours: availableHours ?? {},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('services')
          .doc(serviceId)
          .set(service.toJson());

      return service;
    } catch (e) {
      throw 'Erro ao criar serviço: $e';
    }
  }

  // Buscar serviço por ID
  Future<ServiceModel?> getServiceById(String serviceId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('services')
          .doc(serviceId)
          .get();

      if (doc.exists) {
        return ServiceModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw 'Erro ao buscar serviço: $e';
    }
  }

  // Buscar serviços por barbearia
  Future<List<ServiceModel>> getServicesByBarbershop(
    String barbershopId,
  ) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('services')
          .where('barbershopId', isEqualTo: barbershopId)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map(
            (doc) => ServiceModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw 'Erro ao buscar serviços: $e';
    }
  }

  // Atualizar serviço
  Future<void> updateService(ServiceModel service) async {
    try {
      final updatedService = service.copyWith(updatedAt: DateTime.now());

      await _firestore
          .collection('services')
          .doc(service.id)
          .update(updatedService.toJson());
    } catch (e) {
      throw 'Erro ao atualizar serviço: $e';
    }
  }

  // Deletar serviço (soft delete)
  Future<void> deleteService(String serviceId) async {
    try {
      await _firestore.collection('services').doc(serviceId).update({
        'isActive': false,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw 'Erro ao deletar serviço: $e';
    }
  }

  // Buscar serviços ativos por barbearia
  Future<List<ServiceModel>> getActiveServicesByBarbershop(
    String barbershopId,
  ) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('services')
          .where('barbershopId', isEqualTo: barbershopId)
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();

      return querySnapshot.docs
          .map(
            (doc) => ServiceModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw 'Erro ao buscar serviços ativos: $e';
    }
  }

  // Verificar se existe serviço com o mesmo nome na barbearia
  Future<bool> serviceExists(
    String name,
    String barbershopId, {
    String? excludeId,
  }) async {
    try {
      Query query = _firestore
          .collection('services')
          .where('name', isEqualTo: name)
          .where('barbershopId', isEqualTo: barbershopId)
          .where('isActive', isEqualTo: true);

      if (excludeId != null) {
        query = query.where(FieldPath.documentId, isNotEqualTo: excludeId);
      }

      final QuerySnapshot querySnapshot = await query.get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw 'Erro ao verificar existência do serviço: $e';
    }
  }
}

