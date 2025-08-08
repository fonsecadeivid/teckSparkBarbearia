import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../../../shared/stores/appointment_store.dart';
import '../../../../shared/stores/service_store.dart';
import '../../../../shared/stores/client_store.dart';
import '../../../../shared/stores/auth_store.dart';
import '../../../../shared/models/service_model.dart';
import '../../../../shared/models/client_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  ServiceModel? _selectedService;
  ClientModel? _selectedClient;
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _loadData() {
    final authStore = context.read<AuthStore>();
    final serviceStore = context.read<ServiceStore>();
    final clientStore = context.read<ClientStore>();

    if (authStore.currentUser != null) {
      serviceStore.loadServices(authStore.currentUser!.barbershopId);
      clientStore.loadClients(authStore.currentUser!.barbershopId);
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedTime = null; // Reset time when date changes
      });
      _loadAvailableTimeSlots();
    }
  }

  void _loadAvailableTimeSlots() async {
    if (_selectedService == null) return;

    final appointmentStore = context.read<AppointmentStore>();
    final authStore = context.read<AuthStore>();

    await appointmentStore.getAvailableTimeSlots(
      date: _selectedDate,
      service: _selectedService!,
      barberId: authStore.currentUser?.id ?? '',
      barbershopId: authStore.currentUser?.barbershopId ?? '',
    );
  }

  void _handleCreateAppointment() async {
    if (_selectedService == null ||
        _selectedClient == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos obrigatórios'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final appointmentStore = context.read<AppointmentStore>();
    final authStore = context.read<AuthStore>();

    await appointmentStore.createAppointment(
      clientId: _selectedClient!.id,
      barberId: authStore.currentUser?.id ?? '',
      serviceId: _selectedService!.id,
      barbershopId: authStore.currentUser?.barbershopId ?? '',
      scheduledDate: _selectedDate,
      scheduledTime: _selectedTime!,
      duration: _selectedService!.duration,
      totalPrice: _selectedService!.price,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      clientName: _selectedClient!.name,
      serviceName: _selectedService!.name,
      barberName: authStore.currentUser?.name,
    );

    if (appointmentStore.errorMessage == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agendamento criado com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Agendamento'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título
              Text(
                'Agendar Serviço',
                style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Selecione o serviço, cliente e horário',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Seleção de serviço
              _buildServiceSelection(),
              const SizedBox(height: 24),

              // Seleção de cliente
              _buildClientSelection(),
              const SizedBox(height: 24),

              // Seleção de data
              _buildDateSelection(),
              const SizedBox(height: 24),

              // Seleção de horário
              _buildTimeSelection(),
              const SizedBox(height: 24),

              // Campo de observações
              _buildNotesField(),
              const SizedBox(height: 32),

              // Botão de agendamento
              _buildAppointmentButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceSelection() {
    return Observer(
      builder: (_) {
        final serviceStore = context.read<ServiceStore>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Serviço *',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            if (serviceStore.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (serviceStore.services.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textSecondary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Nenhum serviço disponível'),
              )
            else
              DropdownButtonFormField<ServiceModel>(
                value: _selectedService,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.content_cut),
                ),
                hint: const Text('Selecione um serviço'),
                items: serviceStore.services.map((service) {
                  return DropdownMenuItem(
                    value: service,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(service.name),
                        Text(
                          '${service.formattedPrice} • ${service.formattedDuration}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (service) {
                  setState(() {
                    _selectedService = service;
                    _selectedTime = null;
                  });
                  if (service != null) {
                    _loadAvailableTimeSlots();
                  }
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildClientSelection() {
    return Observer(
      builder: (_) {
        final clientStore = context.read<ClientStore>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cliente *',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            if (clientStore.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (clientStore.clients.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textSecondary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Nenhum cliente cadastrado'),
              )
            else
              DropdownButtonFormField<ClientModel>(
                value: _selectedClient,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                hint: const Text('Selecione um cliente'),
                items: clientStore.clients.map((client) {
                  return DropdownMenuItem(
                    value: client,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(client.name),
                        Text(
                          client.email,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (client) {
                  setState(() {
                    _selectedClient = client;
                  });
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data *',
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.textSecondary),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 12),
                Text(
                  '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelection() {
    return Observer(
      builder: (_) {
        final appointmentStore = context.read<AppointmentStore>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Horário *',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            if (_selectedService == null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textSecondary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Selecione um serviço primeiro'),
              )
            else if (appointmentStore.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (appointmentStore.availableTimeSlots.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textSecondary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Nenhum horário disponível para esta data'),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: appointmentStore.availableTimeSlots.map((time) {
                  final isSelected = _selectedTime == time;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedTime = time;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surface,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        time,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isSelected
                              ? AppColors.surface
                              : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        );
      },
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Observações',
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _notesController,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.note),
            hintText: 'Observações adicionais (opcional)',
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentButton() {
    return Observer(
      builder: (_) {
        final appointmentStore = context.read<AppointmentStore>();

        return Column(
          children: [
            if (appointmentStore.errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.error),
                ),
                child: Text(
                  appointmentStore.errorMessage!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: appointmentStore.isLoading
                  ? null
                  : _handleCreateAppointment,
              child: appointmentStore.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.surface,
                        ),
                      ),
                    )
                  : const Text('Agendar'),
            ),
          ],
        );
      },
    );
  }
}

