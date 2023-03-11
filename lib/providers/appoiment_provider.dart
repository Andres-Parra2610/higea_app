

import 'package:flutter/material.dart';
import 'package:higea_app/helpers/helpers.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/services/services.dart';

class AppoimentProvider extends ChangeNotifier{

  List<Appoiment> appoiments = [];
  bool loading = false;
  String date = '';

  Future<Doctor> showDoctorDatesWork(ci) async{

    final Map<String, dynamic> response = await DoctorServices.getDoctorDatesWork(ci);

    final doctor = Doctor.fromJson(response['results']);

    final currentDay = Helpers.parsedDate(doctor.fechas![0].split(' ')[1]);
    final showCompleteDate = Helpers.completeDate(doctor.fechas![0]);
    
    await showAppoiment(ci, currentDay, showCompleteDate);
    

    return doctor;
  }

  Future showAppoiment(doctorCi, day, completeDate) async{

    loading = true;
    notifyListeners();

    final Map<String, dynamic> res = await AppoimentService.getAppoiments(doctorCi, day);

    final result = res["results"] as List<dynamic>;
    
    appoiments = List<Appoiment>.from(result.map((a) => Appoiment.fromJson(a)));
    date = completeDate;
    loading = false;
    notifyListeners();
  }


  
}