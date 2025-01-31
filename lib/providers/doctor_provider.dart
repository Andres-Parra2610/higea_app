import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:higea_app/services/services.dart';
import 'package:higea_app/models/models.dart';


/// @class [AppoimentProvider]
/// @description Provider que controla los cambios de estado relacionados con el doctor, como eliminación, creación y a su vez
/// de las especialidades

class DoctorProvider extends ChangeNotifier{

  GlobalKey<FormState> formDoctorKey = GlobalKey<FormState>();
  List<Speciality> specialities = [];
  List<String> selectedDays = [];
  List<Doctor> doctors = [];
  Doctor doctor = Doctor.empty();
  String _searchSpeciality = '';
  bool _render = true;
  bool _isLoading = false;

  String get searchSpeciality => _searchSpeciality;
  bool get render => _render;
  bool get isLoading => _isLoading;

  set searchSpeciality(String q){
    _searchSpeciality = q;
    notifyListeners();
  }

  set isLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  set render(value){
    _render = value;
    notifyListeners();
  }

  Future<List<Speciality>> showSpecialities() async{


    if(_render){
      final Map<String, dynamic> response = await DoctorService.getAllSpecialities();

      if(response['ok'] == false) return specialities = [];

      final results = response['results'] as List<dynamic>;
      specialities =  List<Speciality>.from(results.map((x) => Speciality.fromJson(x)));
      _render = false;
      return specialities;
    }

    return specialities;
    
  }

  Future<List<Doctor>> showDoctorBySpeciality(id) async{
    final Map<String, dynamic> response = await DoctorService.getDoctorBySpeciality(id);
    if(response['ok'] == false) return doctors = [];

    final results = response['results'] as List<dynamic>;
    return doctors = List<Doctor>.from(results.map((x) => Doctor.fromJson(x)));
  }

  Future<List<Doctor>> showAllDoctors() async{
    final Map<String, dynamic> response = await DoctorService.getAllDoctors();
    if(response["ok"] == false) return doctors = [];

    final results = response['results'] as List<dynamic>;
    doctors = List<Doctor>.from(results.map((x) => Doctor.fromJson(x)));
    return doctors;
  }

  Future getSpecialitiesToDropDown() async{
    specialities = await showSpecialities();
    notifyListeners();
  }

  Future registerDoctor() async{
    isLoading = true;
    final Map<String, dynamic> response = await DoctorService.registerDoctor(doctor);
    if(response["ok"] == false) return false;
    isLoading = false;
    return true;
  }

  Future editDoctor() async {
    isLoading = true;
    final Map<String, dynamic> response = await DoctorService.editDoctor(doctor);
    if(response["ok"] == false){
      isLoading = false;
      return false;
    }
    isLoading = false; 
    return true;
  }

  Future deleteDoctor(int doctorCi) async {
    isLoading = true;
    final Map<String, dynamic> response = await DoctorService.removeDoctor(doctorCi);
    if(response["ok"] == false) return false;
    isLoading = false; 
    return true;
  }

}
