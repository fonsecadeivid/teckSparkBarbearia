import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../../../shared/stores/auth_store.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech Spark Barbearia'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).pushNamed('/profile');
            },
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          final authStore = context.read<AuthStore>();
          final user = authStore.currentUser;

          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header com boas-vindas
                  Text(
                    'Olá, ${user.name}!',
                    style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'O que você gostaria de fazer hoje?',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Cards de ação baseados no tipo de usuário
                  Expanded(child: _buildActionCards(context, authStore)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionCards(BuildContext context, AuthStore authStore) {
    final List<Widget> actionCards = [];

    // Dashboard - apenas para donos
    if (authStore.canAccessDashboard) {
      actionCards.add(
        _buildActionCard(
          context,
          'Dashboard',
          Icons.dashboard,
          AppColors.primary,
          () {
            Navigator.of(context).pushNamed('/dashboard');
          },
        ),
      );
    }

    // Cadastrar Barbearia - apenas para donos
    if (authStore.canManageBarbershops) {
      actionCards.add(
        _buildActionCard(
          context,
          'Nova Barbearia',
          Icons.store,
          AppColors.warning,
          () {
            Navigator.of(context).pushNamed('/barbershop/register');
          },
        ),
      );
    }

    // Agendamentos - para barbeiros e clientes
    actionCards.add(
      _buildActionCard(
        context,
        'Agendar',
        Icons.calendar_today,
        AppColors.secondary,
        () {
          Navigator.of(context).pushNamed('/appointments');
        },
      ),
    );

    // Clientes - apenas para barbeiros
    if (authStore.canManageClients) {
      actionCards.add(
        _buildActionCard(context, 'Clientes', Icons.people, AppColors.info, () {
          Navigator.of(context).pushNamed('/clients');
        }),
      );
    }

    // Serviços - apenas para barbeiros
    if (authStore.canManageServices) {
      actionCards.add(
        _buildActionCard(
          context,
          'Serviços',
          Icons.list_alt,
          AppColors.success,
          () {
            Navigator.of(context).pushNamed('/services');
          },
        ),
      );
    }

    // Se não há cards suficientes para 2 colunas, adicionar um card vazio
    if (actionCards.length % 2 == 1) {
      actionCards.add(const SizedBox.shrink());
    }

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: actionCards,
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
