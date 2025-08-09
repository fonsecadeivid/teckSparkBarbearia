import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/client_model.dart';
import 'client_service.dart';

class BirthdayNotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ClientService _clientService = ClientService();

  // Verificar clientes aniversariantes hoje
  Future<List<ClientModel>> getClientsWithBirthdayToday(
    String barbershopId,
  ) async {
    try {
      return await _clientService.getClientsWithBirthdayToday(barbershopId);
    } catch (e) {
      throw 'Erro ao buscar clientes aniversariantes: $e';
    }
  }

  // Verificar clientes aniversariantes nos próximos X dias
  Future<List<ClientModel>> getClientsWithBirthdayInNextDays(
    String barbershopId,
    int days,
  ) async {
    try {
      return await _clientService.getClientsWithBirthdayInNextDays(
        barbershopId,
        days,
      );
    } catch (e) {
      throw 'Erro ao buscar clientes aniversariantes: $e';
    }
  }

  // Enviar notificação de aniversário por email
  Future<void> sendBirthdayEmail(
    ClientModel client,
    String barbershopName,
  ) async {
    try {
      // TODO: Implementar integração com serviço de email
      // Por enquanto, apenas log
      print(
        '🎂 Enviando email de aniversário para ${client.name} (${client.email})',
      );

      // Salvar log da notificação
      await _firestore.collection('birthday_notifications').add({
        'clientId': client.id,
        'clientName': client.name,
        'clientEmail': client.email,
        'barbershopId': client.barbershopId,
        'barbershopName': barbershopName,
        'notificationType': 'email',
        'sentAt': DateTime.now().toIso8601String(),
        'status': 'sent',
      });
    } catch (e) {
      throw 'Erro ao enviar email de aniversário: $e';
    }
  }

  // Enviar notificação de aniversário por SMS
  Future<void> sendBirthdaySMS(
    ClientModel client,
    String barbershopName,
  ) async {
    try {
      // TODO: Implementar integração com serviço de SMS
      // Por enquanto, apenas log
      print(
        '🎂 Enviando SMS de aniversário para ${client.name} (${client.phone})',
      );

      // Salvar log da notificação
      await _firestore.collection('birthday_notifications').add({
        'clientId': client.id,
        'clientName': client.name,
        'clientPhone': client.phone,
        'barbershopId': client.barbershopId,
        'barbershopName': barbershopName,
        'notificationType': 'sms',
        'sentAt': DateTime.now().toIso8601String(),
        'status': 'sent',
      });
    } catch (e) {
      throw 'Erro ao enviar SMS de aniversário: $e';
    }
  }

  // Enviar notificação de aniversário por WhatsApp
  Future<void> sendBirthdayWhatsApp(
    ClientModel client,
    String barbershopName,
  ) async {
    try {
      // TODO: Implementar integração com WhatsApp Business API
      // Por enquanto, apenas log
      print(
        '🎂 Enviando WhatsApp de aniversário para ${client.name} (${client.phone})',
      );

      // Salvar log da notificação
      await _firestore.collection('birthday_notifications').add({
        'clientId': client.id,
        'clientName': client.name,
        'clientPhone': client.phone,
        'barbershopId': client.barbershopId,
        'barbershopName': barbershopName,
        'notificationType': 'whatsapp',
        'sentAt': DateTime.now().toIso8601String(),
        'status': 'sent',
      });
    } catch (e) {
      throw 'Erro ao enviar WhatsApp de aniversário: $e';
    }
  }

  // Enviar notificação de aniversário por push notification
  Future<void> sendBirthdayPushNotification(
    ClientModel client,
    String barbershopName,
  ) async {
    try {
      // TODO: Implementar integração com Firebase Messaging
      // Por enquanto, apenas log
      print('🎂 Enviando push notification de aniversário para ${client.name}');

      // Salvar log da notificação
      await _firestore.collection('birthday_notifications').add({
        'clientId': client.id,
        'clientName': client.name,
        'barbershopId': client.barbershopId,
        'barbershopName': barbershopName,
        'notificationType': 'push',
        'sentAt': DateTime.now().toIso8601String(),
        'status': 'sent',
      });
    } catch (e) {
      throw 'Erro ao enviar push notification de aniversário: $e';
    }
  }

  // Enviar todas as notificações de aniversário para um cliente
  Future<void> sendAllBirthdayNotifications(
    ClientModel client,
    String barbershopName,
    List<String> notificationTypes,
  ) async {
    try {
      for (String type in notificationTypes) {
        switch (type.toLowerCase()) {
          case 'email':
            await sendBirthdayEmail(client, barbershopName);
            break;
          case 'sms':
            await sendBirthdaySMS(client, barbershopName);
            break;
          case 'whatsapp':
            await sendBirthdayWhatsApp(client, barbershopName);
            break;
          case 'push':
            await sendBirthdayPushNotification(client, barbershopName);
            break;
        }
      }
    } catch (e) {
      throw 'Erro ao enviar notificações de aniversário: $e';
    }
  }

  // Verificar e enviar notificações de aniversário automaticamente
  Future<void> checkAndSendBirthdayNotifications(
    String barbershopId,
    String barbershopName,
  ) async {
    try {
      // Buscar clientes aniversariantes hoje
      final clientsWithBirthday = await getClientsWithBirthdayToday(
        barbershopId,
      );

      for (ClientModel client in clientsWithBirthday) {
        // Verificar se já foi enviada notificação hoje
        final alreadySent = await _checkIfNotificationAlreadySent(client.id);

        if (!alreadySent) {
          // Enviar notificações (email, SMS, WhatsApp, push)
          await sendAllBirthdayNotifications(client, barbershopName, [
            'email',
            'sms',
            'whatsapp',
            'push',
          ]);
        }
      }
    } catch (e) {
      throw 'Erro ao verificar e enviar notificações de aniversário: $e';
    }
  }

  // Verificar se já foi enviada notificação hoje
  Future<bool> _checkIfNotificationAlreadySent(String clientId) async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final querySnapshot = await _firestore
          .collection('birthday_notifications')
          .where('clientId', isEqualTo: clientId)
          .where('sentAt', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('sentAt', isLessThan: endOfDay.toIso8601String())
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Obter histórico de notificações de aniversário
  Future<List<Map<String, dynamic>>> getBirthdayNotificationHistory(
    String barbershopId, {
    int limit = 50,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('birthday_notifications')
          .where('barbershopId', isEqualTo: barbershopId)
          .orderBy('sentAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw 'Erro ao buscar histórico de notificações: $e';
    }
  }
}
