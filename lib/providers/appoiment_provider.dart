

import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/services/services.dart';

class AppoimentProvider extends ChangeNotifier{

  String _currentDay = '';
  int _currentDoctor = 0;
  List<Appoiment> appoiments = [];

  String get currentDay => _currentDay;
  int get currentDoctor => _currentDoctor;

  set currentDay(String value){
    _currentDay = value;
    notifyListeners();
  }

  set currentDoctor(int value){
    _currentDoctor = value;
    notifyListeners();
  }


  Future<Doctor> showDoctorDatesWork(ci) async{

    final Map<String, dynamic> response = await DoctorServices.getDoctorDatesWork(ci);

    final doctor = Doctor.fromJson(response['results']);

    return doctor;
  }

  Future<List<Appoiment>> showAppoiment() async{
    final Map<String, dynamic> res = await AppoimentService.getAppoiments(currentDoctor, currentDay);

    final result = res["results"] as List<dynamic>;
    
    return appoiments = List<Appoiment>.from(result.map((a) => Appoiment.fromJson(a)));
  }


  
}