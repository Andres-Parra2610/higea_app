import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/services/services.dart';

class RecoveryPasswordProvider extends ChangeNotifier {

  final GlobalKey<FormState> userCiKey = GlobalKey<FormState>();
  final GlobalKey<FormState> codeVerificationKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updatePasswordKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isError = false;
  String userCi = '';
  String codeVerification = '';
  String userPassword = '';
  late dynamic user;

  bool get isLoading => _isLoading;
  bool get isError => _isError;


  set isLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  set isError(bool value){
    _isError = value;
    notifyListeners();
  }

  Future getUserByCi() async {
    isLoading = true;
    Map<String, dynamic> data = await AuthService.getUser(userCi);

    if(data["ok"] == false){
      isLoading = false;
      return false;
    }

    final int idRol = data["user"]["id_rol"] as int;

    if(idRol == 3){
      user = User.fromJson(data['user']);

    }else if(idRol == 2){
      user = Doctor.fromJson(data['user']);

    }else if(idRol == 1){
      user = Admin.fromJson(data['user']);
    }

    isLoading = false;
    return true;
  }

  Future sendCode() async {
    isLoading = true;

    Map<String, dynamic> data = await AuthService.codeVerification(codeVerification);

    if(data['ok'] == false){
      isLoading = false;
      isError = true;
      return false;
    }

    isLoading = true;
    return true;
  }


  Future newPassword() async{

    Map<String, dynamic> reqBody = {'newPassword': userPassword, 'userCi': user.cedula};

    Map<String, dynamic> data = await AuthService.updatePassword(reqBody);

    if(data['ok'] == false) return false;

    return true;
  }
}