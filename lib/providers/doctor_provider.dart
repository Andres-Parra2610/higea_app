import 'package:flutter/material.dart';
import 'package:higea_app/services/services.dart';
import 'package:higea_app/models/models.dart';

class DoctorProvider extends ChangeNotifier{

  List<Speciality> specialities = [];
  List<Doctor> doctors = [];
  late Doctor doctor;
  String _searchSpeciality = '';

  String get searchSpeciality => _searchSpeciality;
  set searchSpeciality(String q){
    _searchSpeciality = q;
    notifyListeners();
  }

  Future<List<Speciality>> showSpecialities() async{
    final Map<String, dynamic> response = await DoctorServices.getAllSpecialities();
    
    if(response['ok'] == false) return specialities = [];

    final results = response['results'] as List<dynamic>;
    return specialities =  List<Speciality>.from(results.map((x) => Speciality.fromJson(x)));
  }

  Future<List<Doctor>> showDoctorBySpeciality(id) async{
    final Map<String, dynamic> response = await DoctorServices.getDoctorBySpeciality(id);
    if(response['ok'] == false) return doctors = [];

    final results = response['results'] as List<dynamic>;
    return doctors = List<Doctor>.from(results.map((x) => Doctor.fromJson(x)));
  }

  Future<Doctor> showDoctorDatesWork(ci) async{
    final Map<String, dynamic> response = await DoctorServices.getDoctorDatesWork(ci);
    
    
    doctor = Doctor.fromJson(response['results']);

    return doctor;
  }

}
