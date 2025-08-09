import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../../../shared/stores/client_store.dart';
import '../../../../shared/stores/auth_store.dart';
import '../../../../shared/models/client_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class BirthdayClientsPage extends StatefulWidget {
  const BirthdayClientsPage({super.key});

  @override
  State<BirthdayClientsPage> createState() => _BirthdayClientsPageState();
}

class _BirthdayClientsPageState extends State<BirthdayClientsPage> {
  int _selectedDays = 7; // Padrão: próximos 7 dias

  @override
  void initState() {
    super.initState();
    _loadBirthdayClients();
  }

  void _loadBirthdayClients() {
    final authStore = context.read<AuthStore>();
    final clientStore = context.read<ClientStore>();

    if (authStore.currentUser != null) {
      clientStore.loadClientsWithBirthdayInNextDays(
        authStore.currentUser!.barbershopId,
        _selectedDays,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes Aniversariantes'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<int>(
            onSelected: (value) {
              setState(() {
                _selectedDays = value;
                _loadBirthdayClients();
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 1, child: Text('Hoje')),
              const PopupMenuItem(value: 7, child: Text('Próximos 7 dias')),
              const PopupMenuItem(value: 15, child: Text('Próximos 15 dias')),
              const PopupMenuItem(value: 30, child: Text('Próximos 30 dias')),
            ],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedDays == 1
                        ? 'Hoje'
                        : 'Próximos $_selectedDays dias',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          final clientStore = context.read<ClientStore>();

          if (clientStore.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (clientStore.clients.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cake_outlined,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum cliente aniversariante',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedDays == 1
                        ? 'Nenhum cliente faz aniversário hoje'
                        : 'Nenhum cliente faz aniversário nos próximos $_selectedDays dias',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadBirthdayClients();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: clientStore.clients.length,
              itemBuilder: (context, index) {
                final client = clientStore.clients[index];
                final daysUntilBirthday = _calculateDaysUntilBirthday(client);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: client.isBirthdayToday
                          ? AppColors.success
                          : AppColors.primary,
                      child: Icon(
                        Icons.cake,
                        color: Colors.white,
                        size: client.isBirthdayToday ? 24 : 20,
                      ),
                    ),
                    title: Text(
                      client.name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: client.isBirthdayToday
                            ? AppColors.success
                            : AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(client.email, style: AppTextStyles.bodySmall),
                        Text(client.phone, style: AppTextStyles.bodySmall),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: client.isBirthdayToday
                                  ? AppColors.success
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${client.formattedBirthDate} (${client.age} anos)',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: client.isBirthdayToday
                                    ? AppColors.success
                                    : AppColors.textSecondary,
                                fontWeight: client.isBirthdayToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (client.isBirthdayToday) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '🎂 HOJE!',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ] else ...[
                          Text(
                            daysUntilBirthday == 1
                                ? 'Amanhã'
                                : 'Em $daysUntilBirthday dias',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  int _calculateDaysUntilBirthday(ClientModel client) {
    if (client.birthDate == null) return 0;

    final now = DateTime.now();
    final nextBirthday = DateTime(
      now.year,
      client.birthDate!.month,
      client.birthDate!.day,
    );

    // Se o aniversário já passou este ano, verificar para o próximo ano
    if (nextBirthday.isBefore(now)) {
      final nextYearBirthday = DateTime(
        now.year + 1,
        client.birthDate!.month,
        client.birthDate!.day,
      );
      return nextYearBirthday.difference(now).inDays;
    } else {
      return nextBirthday.difference(now).inDays;
    }
  }
}
