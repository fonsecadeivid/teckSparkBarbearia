import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../../../shared/stores/service_store.dart';
import '../../../../shared/stores/auth_store.dart';
import '../../../../shared/models/service_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'service_register_page.dart';

class ServicesListPage extends StatefulWidget {
  const ServicesListPage({super.key});

  @override
  State<ServicesListPage> createState() => _ServicesListPageState();
}

class _ServicesListPageState extends State<ServicesListPage> {
  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  void _loadServices() {
    final authStore = context.read<AuthStore>();
    final serviceStore = context.read<ServiceStore>();

    if (authStore.currentUser != null) {
      serviceStore.loadServices(authStore.currentUser!.barbershopId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Serviços'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadServices),
        ],
      ),
      body: Observer(
        builder: (_) {
          final serviceStore = context.read<ServiceStore>();

          if (serviceStore.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (serviceStore.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text('Erro ao carregar serviços', style: AppTextStyles.h4),
                  const SizedBox(height: 8),
                  Text(
                    serviceStore.errorMessage!,
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadServices,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          if (!serviceStore.hasServices) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.content_cut_outlined,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text('Nenhum serviço cadastrado', style: AppTextStyles.h4),
                  const SizedBox(height: 8),
                  Text(
                    'Cadastre seu primeiro serviço para começar',
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
            onRefresh: () async => _loadServices(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: serviceStore.services.length,
              itemBuilder: (context, index) {
                final service = serviceStore.services[index];
                return _buildServiceCard(service);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ServiceRegisterPage(),
            ),
          );
          _loadServices(); // Recarregar lista após cadastro
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildServiceCard(ServiceModel service) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    Icons.content_cut,
                    color: AppColors.surface,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service.description,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleMenuAction(value, service),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Editar'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: AppColors.error),
                          SizedBox(width: 8),
                          Text(
                            'Excluir',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoChip(
                  Icons.access_time,
                  service.formattedDuration,
                  AppColors.info,
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  Icons.attach_money,
                  service.formattedPrice,
                  AppColors.success,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: service.isActive
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: service.isActive
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ),
                  child: Text(
                    service.isActive ? 'Ativo' : 'Inativo',
                    style: AppTextStyles.caption.copyWith(
                      color: service.isActive
                          ? AppColors.success
                          : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (service.availableDays.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Dias disponíveis:',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: service.availableDays.map((day) {
                  final dayNames = {
                    'monday': 'Seg',
                    'tuesday': 'Ter',
                    'wednesday': 'Qua',
                    'thursday': 'Qui',
                    'friday': 'Sex',
                    'saturday': 'Sáb',
                    'sunday': 'Dom',
                  };
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      dayNames[day] ?? day,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontSize: 10,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action, ServiceModel service) {
    switch (action) {
      case 'edit':
        // TODO: Implementar edição
        break;
      case 'delete':
        _showDeleteDialog(service);
        break;
    }
  }

  void _showDeleteDialog(ServiceModel service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Serviço'),
        content: Text(
          'Tem certeza que deseja excluir o serviço "${service.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteService(service.id);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _deleteService(String serviceId) {
    final serviceStore = context.read<ServiceStore>();
    serviceStore.deleteService(serviceId);
  }
}

