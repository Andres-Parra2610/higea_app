import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/services/services.dart';



class AuthProvider extends ChangeNotifier{


  //Datos del formulatio de inicio de sesión
  GlobalKey<FormState> formLoginKey = GlobalKey<FormState>();
  Map<String, dynamic> formLoginValues = {
    'ci': '',
    'password': ''
  };

  //Datos del formluario de registro de usuario
  GlobalKey<FormState> formRegisterKey = GlobalKey<FormState>();
  Map <String, dynamic> formRegisterValues = {
    'name': '',
    'lastName': '',
    'ci': '',
    'email': '',
    'phone': '',
    'birthDate': '',
    'password': ''
  };

  late User currentUser;
  late Doctor currentDoctor;
  late Admin currentAdmin;
  int idRol = 0;

  bool _loading = false;


  bool get loading => _loading;


  set loading(bool value){
    _loading = value;
    notifyListeners();
  }


  Future loginUser() async{

    final String ci = formLoginValues['ci'];
    final String password = formLoginValues['password'];

    Map<String, dynamic> data = await AuthService.loginUser(ci, password);


    if(data.containsKey('idRol')){

      final user = jsonEncode(data['user']);
      final preferences = UserPreferences.setUser = user;

      if(data['idRol'] == 3){
        idRol = 3;
        UserPreferences.setIdRol = idRol;
        currentUser = User.fromRawJson(preferences);
      }else if(data['idRol'] == 2){
        idRol = 2;
        UserPreferences.setIdRol = idRol;
        currentDoctor = Doctor.fromRawJson(preferences);
      }else if(data['idRol'] == 1){
        idRol = 1;
        UserPreferences.setIdRol = idRol;
        currentAdmin = Admin.fromRawJson(user);
      }

      return true;
    }

    return false;
  } 


  Future<Response> registerUser() async{

    Map<String, dynamic> data = await AuthService.registerUser(formRegisterValues);

    return Response.fromJson(data);
  }

  Future confirmEmail(String codeVerication) async{

    formRegisterValues['codeVerification'] = codeVerication;
    Map<String, dynamic> data = await AuthService.confirmEmail(formRegisterValues);

    if(data['ok'] == false){
      return false;
    }
    final user = jsonEncode(data['user']);
    final preferences = UserPreferences.setUser = user;
    final createGlobalUser = User.fromRawJson(preferences);
    currentUser = createGlobalUser;
    return true;
  }


}