
import 'package:flutter/material.dart';
import 'package:higea_app/screens/screens.dart';
import 'package:higea_app/services/services.dart';

class SessionScreen extends StatelessWidget {
const SessionScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
   
    if(UserPreferences.user == ''){
      Future.microtask((){
        Navigator.pushReplacement(context, PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionDuration: const Duration(seconds: 0)
        ));
      });
    }else{
      Future.microtask((){
        Navigator.pushReplacement(context, PageRouteBuilder(
          pageBuilder: (_, __, ___) => const PageTabScreen(),
          transitionDuration: const Duration(seconds: 0)
        ));
      });
    }

    return const Scaffold();
  }
}