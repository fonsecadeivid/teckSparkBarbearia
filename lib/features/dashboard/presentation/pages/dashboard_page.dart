import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../../../shared/stores/appointment_store.dart';
import '../../../../shared/stores/client_store.dart';
import '../../../../shared/stores/service_store.dart';
import '../../../../shared/stores/auth_store.dart';
import '../../../../shared/models/appointment_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/metric_card.dart';
import '../widgets/appointments_chart.dart';
import '../widgets/revenue_chart.dart';
import '../widgets/today_appointments_list.dart';
import '../widgets/popular_services_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    final authStore = context.read<AuthStore>();
    final appointmentStore = context.read<AppointmentStore>();
    final clientStore = context.read<ClientStore>();
    final serviceStore = context.read<ServiceStore>();

    if (authStore.currentUser != null) {
      final barbershopId = authStore.currentUser!.barbershopId;

      // Carregar dados em paralelo
      appointmentStore.loadAppointments(barbershopId);
      clientStore.loadClients(barbershopId);
      serviceStore.loadServices(barbershopId);
    }
  }

  Future<void> _loadDashboardDataAsync() async {
    final authStore = context.read<AuthStore>();
    final appointmentStore = context.read<AppointmentStore>();
    final clientStore = context.read<ClientStore>();
    final serviceStore = context.read<ServiceStore>();

    if (authStore.currentUser != null) {
      final barbershopId = authStore.currentUser!.barbershopId;

      // Carregar dados em paralelo
      await Future.wait([
        appointmentStore.loadAppointments(barbershopId),
        clientStore.loadClients(barbershopId),
        serviceStore.loadServices(barbershopId),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final authStore = context.read<AuthStore>();

        // Verificar se o usuário tem acesso ao dashboard
        if (!authStore.canAccessDashboard) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Dashboard'),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text('Acesso Negado', style: AppTextStyles.h3),
                  const SizedBox(height: 8),
                  Text(
                    'Apenas donos da barbearia podem acessar o dashboard.',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => _loadDashboardData(),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _loadDashboardDataAsync,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeHeader(),
                  const SizedBox(height: 24),
                  _buildMetricsCards(),
                  const SizedBox(height: 24),
                  _buildChartsSection(),
                  const SizedBox(height: 24),
                  _buildTodayAppointments(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeHeader() {
    return Observer(
      builder: (_) {
        final authStore = context.read<AuthStore>();
        final userName = authStore.currentUser?.name ?? 'Usuário';

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.dashboard,
                    size: 30,
                    color: AppColors.surface,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bem-vindo, $userName!',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Aqui está o resumo da sua barbearia',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricsCards() {
    return Observer(
      builder: (_) {
        final appointmentStore = context.read<AppointmentStore>();
        final clientStore = context.read<ClientStore>();
        final serviceStore = context.read<ServiceStore>();

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            MetricCard(
              title: 'Agendamentos Hoje',
              value: appointmentStore.todayAppointments.length.toString(),
              icon: Icons.calendar_today,
              color: AppColors.primary,
              subtitle:
                  '${appointmentStore.pendingAppointments.length} pendentes',
            ),
            MetricCard(
              title: 'Clientes Ativos',
              value: clientStore.clients.length.toString(),
              icon: Icons.people,
              color: AppColors.secondary,
              subtitle:
                  '${clientStore.clients.where((c) => c.createdAt.isAfter(DateTime.now().subtract(const Duration(days: 30)))).length} este mês',
            ),
            MetricCard(
              title: 'Serviços Ativos',
              value: serviceStore.services
                  .where((s) => s.isActive)
                  .length
                  .toString(),
              icon: Icons.content_cut,
              color: AppColors.info,
              subtitle: '${serviceStore.services.length} total',
            ),
            MetricCard(
              title: 'Faturamento Mensal',
              value: _calculateMonthlyRevenue(),
              icon: Icons.attach_money,
              color: AppColors.success,
              subtitle: 'R\$ ${_calculateMonthlyRevenue()}',
            ),
          ],
        );
      },
    );
  }

  Widget _buildChartsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Análises',
          style: AppTextStyles.h4.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Gráfico de agendamentos
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Agendamentos por Dia',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 200, child: AppointmentsChart()),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Gráfico de faturamento
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Faturamento Semanal',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 200, child: RevenueChart()),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Gráfico de serviços populares
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Serviços Mais Populares',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 200, child: PopularServicesChart()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTodayAppointments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Agendamentos de Hoje',
          style: AppTextStyles.h4.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const TodayAppointmentsList(),
      ],
    );
  }

  String _calculateMonthlyRevenue() {
    final appointmentStore = context.read<AppointmentStore>();
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    final monthlyAppointments = appointmentStore.appointments.where((
      appointment,
    ) {
      return appointment.scheduledDate.isAfter(startOfMonth) &&
          appointment.scheduledDate.isBefore(endOfMonth) &&
          appointment.status == AppointmentStatus.completed;
    }).toList();

    final totalRevenue = monthlyAppointments.fold<double>(
      0.0,
      (sum, appointment) => sum + appointment.totalPrice,
    );

    return totalRevenue.toStringAsFixed(2);
  }
}
