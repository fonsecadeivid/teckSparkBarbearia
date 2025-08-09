import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../../../shared/stores/auth_store.dart';
import '../../../../shared/stores/barbershop_store.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../features/home/presentation/pages/home_page.dart';
import '../../../../features/barbershop/presentation/pages/barbershop_register_page.dart';

class RegisterPage extends StatefulWidget {
  final String userType;

  const RegisterPage({super.key, required this.userType});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _addressController = TextEditingController();
  final _barbershopNameController = TextEditingController();
  final _birthDateController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  DateTime? _selectedBirthDate;
  String? _selectedBarbershopId;
  List<Map<String, dynamic>> _availableBarbershops = [];

  @override
  void initState() {
    super.initState();
    if (widget.userType == 'client') {
      _loadBarbershops();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cpfCnpjController.dispose();
    _addressController.dispose();
    _barbershopNameController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _loadBarbershops() async {
    final barbershopStore = context.read<BarbershopStore>();
    await barbershopStore.loadActiveBarbershops();

    setState(() {
      _availableBarbershops = barbershopStore.barbershops
          .map((barbershop) => {'id': barbershop.id, 'name': barbershop.name})
          .toList();
    });
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        const Duration(days: 6570),
      ), // 18 anos atrás
      firstDate: DateTime.now().subtract(
        const Duration(days: 36500),
      ), // 100 anos atrás
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final authStore = context.read<AuthStore>();

      await authStore.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        userType: widget.userType,
        barbershopId: widget.userType == 'client'
            ? _selectedBarbershopId ?? ''
            : '',
        cpfCnpj: widget.userType == 'owner'
            ? _cpfCnpjController.text.trim()
            : null,
        address: widget.userType == 'owner'
            ? _addressController.text.trim()
            : null,
        barbershopName: widget.userType == 'owner'
            ? _barbershopNameController.text.trim()
            : null,
      );

      if (authStore.isLoggedIn && mounted) {
        // Se for dono, redirecionar para cadastro de barbearia
        if (widget.userType == 'owner') {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const BarbershopRegisterPage(),
            ),
            (route) => false,
          );
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.userType == 'client'
              ? 'Cadastro de Cliente'
              : 'Cadastro de Proprietário',
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Título
                Text(
                  widget.userType == 'client'
                      ? 'Cadastro de Cliente'
                      : 'Cadastro de Proprietário',
                  style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.userType == 'client'
                      ? 'Preencha os dados para criar sua conta de cliente'
                      : 'Preencha os dados para criar sua conta de proprietário',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Campo de nome
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nome completo',
                    prefixIcon: Icon(Icons.person_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu nome';
                    }
                    if (value.length < 3) {
                      return 'O nome deve ter pelo menos 3 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo de email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu e-mail';
                    }
                    if (!value.contains('@')) {
                      return 'Por favor, insira um e-mail válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo de telefone
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Telefone/WhatsApp',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu telefone';
                    }
                    if (value.length < 10) {
                      return 'Por favor, insira um telefone válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campos específicos para cliente
                if (widget.userType == 'client') ...[
                  // Campo de data de nascimento
                  InkWell(
                    onTap: () => _selectBirthDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.grey),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedBirthDate != null
                                  ? 'Data de Nascimento: ${_birthDateController.text}'
                                  : 'Data de Nascimento (opcional)',
                              style: TextStyle(
                                color: _selectedBirthDate != null
                                    ? Colors.black
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                          if (_selectedBirthDate != null)
                            IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  _selectedBirthDate = null;
                                  _birthDateController.clear();
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campo de seleção de barbearia
                  DropdownButtonFormField<String>(
                    value: _selectedBarbershopId,
                    decoration: const InputDecoration(
                      labelText: 'Barbearia',
                      prefixIcon: Icon(Icons.store),
                    ),
                    items: _availableBarbershops.map((barbershop) {
                      return DropdownMenuItem<String>(
                        value: barbershop['id'] as String,
                        child: Text(barbershop['name'] as String),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBarbershopId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecione uma barbearia';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Campos específicos para proprietário
                if (widget.userType == 'owner') ...[
                  // Campo de CPF/CNPJ
                  TextFormField(
                    controller: _cpfCnpjController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'CPF/CNPJ',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu CPF ou CNPJ';
                      }
                      if (value.length < 11) {
                        return 'Por favor, insira um CPF ou CNPJ válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo de endereço
                  TextFormField(
                    controller: _addressController,
                    keyboardType: TextInputType.streetAddress,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Endereço completo',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu endereço';
                      }
                      if (value.length < 10) {
                        return 'Por favor, insira um endereço válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo de nome da barbearia
                  TextFormField(
                    controller: _barbershopNameController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nome da Barbearia',
                      prefixIcon: Icon(Icons.store_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome da barbearia';
                      }
                      if (value.length < 3) {
                        return 'O nome da barbearia deve ter pelo menos 3 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Campo de senha
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo de confirmar senha
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirmar senha',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, confirme sua senha';
                    }
                    if (value != _passwordController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Botão de cadastro
                Observer(
                  builder: (_) {
                    final authStore = context.read<AuthStore>();
                    return Column(
                      children: [
                        if (authStore.errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.error),
                            ),
                            child: Text(
                              authStore.errorMessage!,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ElevatedButton(
                          onPressed: authStore.isLoading
                              ? null
                              : _handleRegister,
                          child: authStore.isLoading
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
                              : Text(
                                  widget.userType == 'client'
                                      ? 'Cadastrar Cliente'
                                      : 'Cadastrar Proprietário',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.surface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
