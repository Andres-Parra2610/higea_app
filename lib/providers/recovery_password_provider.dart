import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/services/services.dart';

class RecoveryPasswordProvider extends ChangeNotifier {

  final GlobalKey<FormState> userCiKey = GlobalKey<FormState>();
  final GlobalKey<FormState> codeVerificationKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updatePasswordKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String userCi = '';
  String codeVerification = '';
  String userPassword = '';
  late User user;

  bool get isLoading => _isLoading;

  set isLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  Future getPatientByCi() async {
    isLoading = true;

    Map<String, dynamic> data = await AuthService.getPatient(userCi);

    if(data["ok"] == false){
      isLoading = false;
      return false;
    }

    user = User.fromJson(data['user']);
    isLoading = false;
    return true;
  }
}