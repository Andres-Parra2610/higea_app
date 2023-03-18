
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

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]);
  await NotificationService.initNotification();
  await UserPreferences.initPreferences();
  await dotenv.load(fileName: '.env');


  runApp(const MyAppState());
}


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
      ],
      child: const MyApp(),
    );
  }

}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('es_ES');
    return MaterialApp(
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
        //'recovery_password': (_) => const RecoveryPassword()
      },
    );
  }

}