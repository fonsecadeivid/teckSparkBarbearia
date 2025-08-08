import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'shared/stores/auth_store.dart';
import 'shared/stores/client_store.dart';
import 'shared/stores/service_store.dart';
import 'shared/stores/appointment_store.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/clients/presentation/pages/clients_list_page.dart';
import 'features/clients/presentation/pages/client_register_page.dart';
import 'features/services/presentation/pages/services_list_page.dart';
import 'features/services/presentation/pages/service_register_page.dart';
import 'features/appointments/presentation/pages/appointment_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthStore>(create: (_) => AuthStore()),
        Provider<ClientStore>(create: (_) => ClientStore()),
        Provider<ServiceStore>(create: (_) => ServiceStore()),
        Provider<AppointmentStore>(create: (_) => AppointmentStore()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech Spark Barbearia',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/clients': (context) => const ClientsListPage(),
        '/clients/register': (context) => const ClientRegisterPage(),
        '/services': (context) => const ServicesListPage(),
        '/services/register': (context) => const ServiceRegisterPage(),
        '/appointments': (context) => const AppointmentPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
