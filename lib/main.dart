
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';

import 'package:higea_app/services/services.dart';
import 'package:higea_app/widgets/widgets.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/styles/app_theme.dart'; 
import 'package:higea_app/screens/screens.dart';




/// @function [main]
/// @description Función principal de la aplicación, este es el punto de entrada
void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]);
  await NotificationService.initNotification();
  await UserPreferences.initPreferences();
  await dotenv.load(fileName: '.env');
  await initializeDateFormatting();
  
  runApp(const MyAppState());
}

/// @class [MyAppState]
/// @description Clase que sirve para crear los diferentes providers o proveedores de estado de la app
class MyAppState extends StatelessWidget{
  const MyAppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => DoctorProvider()),
        ChangeNotifierProvider(create: (context) => AppoimentProvider()),
        ChangeNotifierProvider(create: (context) => RecoveryPasswordProvider()),
        ChangeNotifierProvider(create: (context) => CalendarProvider()),
        ChangeNotifierProvider(create: (context) => HistoryProvider()),
        ChangeNotifierProvider(create: (context) => PatientProvider()),
        ChangeNotifierProvider(create: (context) => GuestProvider()),
      ],
      child: const MyApp(),
    );
  }

}

/// @class [MyApp]
/// @description Clase que es la primera que muestra la app con sus diferentes configuraciones
class MyApp extends StatelessWidget{
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('es_ES');
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        title: 'Higea Fundation Aplication',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        scaffoldMessengerKey: SnackBarWidget.scaffoldKey,
        initialRoute: 'session',
        routes: {
          'login': (_) => const LoginScreen(),
          'register': (_) => const RegisterScreen(),
          'confirm': (_) => const ConfirmEmailScreen(),
          'home-client': (_) => const IndexScreen(),
          'session': (_) => const SessionScreen(),
        },
      ),
    );
  }

}