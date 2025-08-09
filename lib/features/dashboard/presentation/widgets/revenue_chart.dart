import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/stores/appointment_store.dart';
import '../../../../../shared/models/appointment_model.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

class RevenueChart extends StatelessWidget {
  const RevenueChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final appointmentStore = context.read<AppointmentStore>();
        final data = _getRevenueData(appointmentStore.appointments);

        if (data.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: data.map((item) {
                  final maxValue = data.map((e) => e['revenue'] as double).reduce((a, b) => a > b ? a : b);
                  final height = maxValue > 0 ? (item['revenue'] as double) / maxValue : 0.0;
                  
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 30,
                            height: 120 * height,
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                'R\$ ${(item['revenue'] as double).toStringAsFixed(0)}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.surface,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['day'],
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> _getRevenueData(List appointments) {
    final now = DateTime.now();
    final data = <Map<String, dynamic>>[];
    
    // Últimos 7 dias
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayName = _getDayName(date.weekday);
      
      final dayAppointments = appointments.where((appointment) {
        return appointment.scheduledDate.year == date.year &&
               appointment.scheduledDate.month == date.month &&
               appointment.scheduledDate.day == date.day &&
               appointment.status == AppointmentStatus.completed;
      }).toList();
      
      final revenue = dayAppointments.fold<double>(
        0.0,
        (sum, appointment) => sum + appointment.totalPrice,
      );
      
      data.add({
        'day': dayName,
        'revenue': revenue,
      });
    }
    
    return data;
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Seg';
      case 2:
        return 'Ter';
      case 3:
        return 'Qua';
      case 4:
        return 'Qui';
      case 5:
        return 'Sex';
      case 6:
        return 'Sáb';
      case 7:
        return 'Dom';
      default:
        return '';
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.trending_up,
            size: 48,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum faturamento registrado',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
