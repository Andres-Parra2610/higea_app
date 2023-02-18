

import 'package:flutter/material.dart';
import 'package:higea_app/styles/app_theme.dart';
import 'package:higea_app/screens/screens.dart';

void main(){
  runApp(const MyApp());
}




class MyApp extends StatelessWidget{
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Higea Fundation Aplication',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: 'login',
      routes: {
        'login': (_) => const LoginScreen(),
        'register': (_) => const RegisterScreen(),
        'confirm': (_) => const ConfirmEmailScreen(),
        'home-client': (_) => const PageTabScreen(),
      },
    );
  }

}