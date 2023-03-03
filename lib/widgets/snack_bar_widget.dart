
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnackBarWidget{

  static final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();


  static showSnackBar(String msg){
    
    final snackBar = SnackBar(
      content: Text(msg, style: const TextStyle(fontSize: 15),),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
    );

    scaffoldKey.currentState!.showSnackBar(snackBar);
  }

}