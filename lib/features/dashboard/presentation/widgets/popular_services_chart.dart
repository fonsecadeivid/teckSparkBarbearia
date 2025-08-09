import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/stores/appointment_store.dart';
import '../../../../../shared/stores/service_store.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

class PopularServicesChart extends StatelessWidget {
  const PopularServicesChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final appointmentStore = context.read<AppointmentStore>();
        final serviceStore = context.read<ServiceStore>();
        final data = _getPopularServicesData(appointmentStore.appointments, serviceStore.services);

        if (data.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  final maxValue = data.map((e) => e['count'] as int).reduce((a, b) => a > b ? a : b);
                  final percentage = maxValue > 0 ? (item['count'] as int) / maxValue : 0.0;
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            item['name'],
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: LinearProgressIndicator(
                            value: percentage,
                            backgroundColor: AppColors.border,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item['count'].toString(),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> _getPopularServicesData(List appointments, List services) {
    final serviceCounts = <String, int>{};
    
    // Contar agendamentos por serviço
    for (final appointment in appointments) {
      final serviceName = appointment.serviceName ?? 'Serviço não identificado';
      serviceCounts[serviceName] = (serviceCounts[serviceName] ?? 0) + 1;
    }
    
    // Converter para lista e ordenar
    final data = serviceCounts.entries.map((entry) {
      return {
        'name': entry.key,
        'count': entry.value,
      };
    }).toList();
    
    // Ordenar por quantidade (decrescente)
    data.sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));
    
    // Retornar apenas os top 5
    return data.take(5).toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pie_chart,
            size: 48,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum serviço registrado',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
