
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:higea_app/providers/providers.dart';
import 'package:higea_app/screens/screens.dart';
import 'package:higea_app/services/services.dart';
import 'package:higea_app/models/models.dart';

class SessionScreen extends StatelessWidget {
const SessionScreen({ Key? key}) : super(key: key);



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

      final idRol = UserPreferences.idRol;
      Widget screen = const IndexScreen();

      if(idRol == 3){
        final user = User.fromRawJson(UserPreferences.user);
        Provider.of<AuthProvider>(context, listen: false).currentUser = user;
      }else{
        final doctor = Doctor.fromRawJson(UserPreferences.user);
        Provider.of<AuthProvider>(context, listen: false).currentDoctor = doctor;
        screen = const HomeDoctorScreen();
      }

      Future.microtask((){
        Navigator.pushReplacement(context, PageRouteBuilder(
          pageBuilder: (_, __, ___) => screen,
          transitionDuration: const Duration(seconds: 0)
        ));
      });
    }

    return const Scaffold();
  }
}