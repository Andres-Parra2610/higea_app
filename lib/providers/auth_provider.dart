
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

  late User user;

  bool _loading = false;
  bool _loadingRegister = false;


  bool get loading => _loading;
  bool get loadingRegister => _loadingRegister; 


  set loading(bool value){
    _loading = value;
    notifyListeners();
  }


  Future loginUser() async{

    final String ci = formLoginValues['ci'];
    final String password = formLoginValues['password'];

    Map<String, dynamic> data = await AuthService.loginUser(ci, password);


    if(data.containsKey('user')){
      user = User.fromJson(data['user']);
      return true;
    }

    return false;
  } 


  Future registerUser() async{
    
    _loadingRegister = true;
    notifyListeners();

    Map<String, dynamic> data = await AuthService.registerUser(formRegisterValues);

    if(data['ok'] == false){
      _loadingRegister = false;
      notifyListeners();
      return false;
    }

    return true;
  }

  Future confirmEmail(String codeVerication) async{


    formRegisterValues['codeVerification'] = codeVerication;

    Map<String, dynamic> data = await AuthService.confirmEmail(formRegisterValues);

    if(data['ok'] == false){
      return false;
    }
    
    return true;
    
  }


}