
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

      final user = User.fromRawJson(UserPreferences.user);
      Provider.of<AuthProvider>(context, listen: false).currentUser = user;

      Future.microtask((){
        Navigator.pushReplacement(context, PageRouteBuilder(
          pageBuilder: (_, __, ___) => const IndexScreen(),
          transitionDuration: const Duration(seconds: 0)
        ));
      });
    }

    return const Scaffold();
  }
}