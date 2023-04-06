import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/services/services.dart';

class PatientProvider extends ChangeNotifier{


  Future<List<User>> showPatient() async{
    final Map<String, dynamic> response = await PatientService.getAllPatient();

    if(response['ok'] == false) return [];
    
    final results = response['results'] as List<dynamic>;
    final List<User> patients = results.map((e) => User.fromJson(e)).toList();
    return patients;
  }
}