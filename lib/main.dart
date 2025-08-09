import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'shared/stores/auth_store.dart';
import 'shared/stores/client_store.dart';
import 'shared/stores/service_store.dart';
import 'shared/stores/appointment_store.dart';
import 'shared/stores/barbershop_store.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/user_type_selection_page.dart';
import 'features/clients/presentation/pages/clients_list_page.dart';
import 'features/clients/presentation/pages/client_register_page.dart';
import 'features/clients/presentation/pages/birthday_clients_page.dart';
import 'features/services/presentation/pages/services_list_page.dart';
import 'features/services/presentation/pages/service_register_page.dart';
import 'features/appointments/presentation/pages/appointment_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/barbershop/presentation/pages/barbershop_register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthStore>(create: (_) => AuthStore()),
        Provider<ClientStore>(create: (_) => ClientStore()),
        Provider<ServiceStore>(create: (_) => ServiceStore()),
        Provider<AppointmentStore>(create: (_) => AppointmentStore()),
        Provider<BarbershopStore>(create: (_) => BarbershopStore()),
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      locale: const Locale('pt', 'BR'),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const UserTypeSelectionPage(),
        '/register/client': (context) => const RegisterPage(userType: 'client'),
        '/register/owner': (context) => const RegisterPage(userType: 'owner'),
        '/dashboard': (context) => const DashboardPage(),
        '/clients': (context) => const ClientsListPage(),
        '/clients/register': (context) => const ClientRegisterPage(),
        '/clients/birthday': (context) => const BirthdayClientsPage(),
        '/services': (context) => const ServicesListPage(),
        '/services/register': (context) => const ServiceRegisterPage(),
        '/appointments': (context) => const AppointmentPage(),
        '/profile': (context) => const ProfilePage(),
        '/barbershop/register': (context) => const BarbershopRegisterPage(),
      },
    );
  }
}
