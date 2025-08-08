import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../../../shared/stores/client_store.dart';
import '../../../../shared/stores/auth_store.dart';
import '../../../../shared/models/client_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'client_register_page.dart';

class ClientsListPage extends StatefulWidget {
  const ClientsListPage({super.key});

  @override
  State<ClientsListPage> createState() => _ClientsListPageState();
}

class _ClientsListPageState extends State<ClientsListPage> {
  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  void _loadClients() {
    final authStore = context.read<AuthStore>();
    final clientStore = context.read<ClientStore>();

    if (authStore.currentUser != null) {
      clientStore.loadClients(authStore.currentUser!.barbershopId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadClients),
        ],
      ),
      body: Observer(
        builder: (_) {
          final clientStore = context.read<ClientStore>();

          if (clientStore.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (clientStore.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text('Erro ao carregar clientes', style: AppTextStyles.h4),
                  const SizedBox(height: 8),
                  Text(
                    clientStore.errorMessage!,
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadClients,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          if (!clientStore.hasClients) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text('Nenhum cliente cadastrado', style: AppTextStyles.h4),
                  const SizedBox(height: 8),
                  Text(
                    'Cadastre seu primeiro cliente para começar',
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
            onRefresh: () async => _loadClients(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: clientStore.clients.length,
              itemBuilder: (context, index) {
                final client = clientStore.clients[index];
                return _buildClientCard(client);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ClientRegisterPage()),
          );
          _loadClients(); // Recarregar lista após cadastro
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildClientCard(ClientModel client) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Text(
            client.name.isNotEmpty ? client.name[0].toUpperCase() : '?',
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.surface,
            ),
          ),
        ),
        title: Text(
          client.name,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.email_outlined,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(client.email, style: AppTextStyles.bodySmall),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.phone_outlined,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(client.phone, style: AppTextStyles.bodySmall),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(value, client),
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
                  Text('Excluir', style: TextStyle(color: AppColors.error)),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          // TODO: Abrir detalhes do cliente
        },
      ),
    );
  }

  void _handleMenuAction(String action, ClientModel client) {
    switch (action) {
      case 'edit':
        // TODO: Implementar edição
        break;
      case 'delete':
        _showDeleteDialog(client);
        break;
    }
  }

  void _showDeleteDialog(ClientModel client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Cliente'),
        content: Text(
          'Tem certeza que deseja excluir o cliente "${client.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteClient(client.id);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _deleteClient(String clientId) {
    final clientStore = context.read<ClientStore>();
    clientStore.deleteClient(clientId);
  }
}

