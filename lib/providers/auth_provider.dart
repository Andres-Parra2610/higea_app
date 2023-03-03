
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
    'gender': ''
  };



  late User user;

  bool _loadingLogin = false;
  bool _showPassword = false;
  bool _loadingRegister = false;

  bool get showPassword => _showPassword;
  bool get loadingLogin => _loadingLogin;
  bool get loadingRegister => _loadingRegister;

  set showPassword(bool value){
    _showPassword = value;
    notifyListeners();
  }

  set loadingLogin(bool value){
    _loadingLogin = value;
    notifyListeners();
  }

  set loadingRegister(bool value){
    _loadingRegister = value;
    notifyListeners();
  }



  Future loginUser() async{

    final String ci = formLoginValues['ci'];
    final String password = formLoginValues['password'];

    loadingLogin = true;

    Map<String, dynamic> data = await AuthService.loginUser(ci, password);


    if(data.containsKey('user')){
      user = User.fromJson(data['user']);
      loadingLogin = false;
      return true;
    }

    loadingLogin = false;
    return false;
  } 


  Future registerUser() async{

    loadingRegister = true;
    
    Map<String, dynamic> data = await AuthService.registerUser(formRegisterValues);

    if(data['ok'] == false){
      loadingRegister = false;
      return false;
    }

    loadingLogin = false;
    return true;
  }

  Future confirmEmail(String codeVerication) async{

    loadingRegister = true;

    formRegisterValues['codeVerification'] = codeVerication;

    Map<String, dynamic> data = await AuthService.confirmEmail(formRegisterValues);

    if(data['ok'] == false){
      return false;
    }
    
    loadingRegister = true;
    return true;
    
  }


}