import 'package:flutter/material.dart';
import 'package:higea_app/styles/app_theme.dart';

class SnackBarWidget{

  static final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();


  static showSnackBar(String msg, [int color = AppTheme.secondaryColor]){
    
    final snackBar = SnackBar(
      content: Text(msg, style: const TextStyle(fontSize: 15),),
      duration: const Duration(seconds: 3),
      backgroundColor:  Color(color),
    );

    scaffoldKey.currentState!.showSnackBar(snackBar);
  }

}