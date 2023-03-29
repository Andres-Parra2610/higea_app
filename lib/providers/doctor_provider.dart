import 'package:flutter/material.dart';
import 'package:higea_app/services/services.dart';
import 'package:higea_app/models/models.dart';

class DoctorProvider extends ChangeNotifier{

  List<Speciality> specialities = [];
  List<Doctor> doctors = [];
  late Doctor doctor;
  String _searchSpeciality = '';
  bool _render = false;

  String get searchSpeciality => _searchSpeciality;
  bool get render => _render;

  set searchSpeciality(String q){
    _searchSpeciality = q;
    notifyListeners();
  }

  set render(value){
    _render = value;
    _render = false;
    notifyListeners();
  }

  Future<List<Speciality>> showSpecialities() async{

    //if(specialities.isNotEmpty && !render) return specialities;
    
    final Map<String, dynamic> response = await DoctorServices.getAllSpecialities();

    
    if(response['ok'] == false) return specialities = [];


    final results = response['results'] as List<dynamic>;
    specialities =  List<Speciality>.from(results.map((x) => Speciality.fromJson(x)));
    return specialities;
  }

  Future<List<Doctor>> showDoctorBySpeciality(id) async{
    final Map<String, dynamic> response = await DoctorServices.getDoctorBySpeciality(id);
    if(response['ok'] == false) return doctors = [];

    final results = response['results'] as List<dynamic>;
    return doctors = List<Doctor>.from(results.map((x) => Doctor.fromJson(x)));
  }


}
