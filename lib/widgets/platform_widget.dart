import 'package:flutter/material.dart';
import 'package:higea_app/screens/screens.dart';
import 'package:higea_app/services/services.dart';

class PlatformWidget extends StatelessWidget {
const PlatformWidget({ Key? key, required this.text }) : super(key: key);


  final String text;

  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text),
              const SizedBox(height: 10,),
              ElevatedButton(
                onPressed: (){
                  UserPreferences.deleteUser();
                  Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(builder: (_) => const SessionScreen()), 
                    (route) => false
                  );
                },  
                child: const Text('Cerrar')
              )
            ],
          )
        ),
      );
  }
}