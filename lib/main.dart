

import 'package:flutter/material.dart';
import 'package:higea_app/screens/screens.dart';

void main(){
  runApp(const MyApp());
}




class MyApp extends StatelessWidget{
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Higea Fundation Aplication',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }

}