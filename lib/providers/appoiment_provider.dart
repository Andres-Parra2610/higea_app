

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:higea_app/helpers/helpers.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/services/services.dart';
import 'package:intl/intl.dart';

class AppoimentProvider extends ChangeNotifier{

  List<Appoiment> appoiments = [];
  List<Appoiment> filterAppoiments = [];
  bool loading = false;
  String date = '';



  Future getAllAppoiments() async{
    final Map<String, dynamic> res = await AppoimentService.getAllAppoiments();
    final result = res["results"] as List<dynamic>;
    
    appoiments = List<Appoiment>.from(result.map((a) => Appoiment.fromJson(a)));
    filterAppoiments = appoiments;

    notifyListeners();
  }

  Future<List<Appoiment>> showAppoimentByPatient(int ci) async{
    final Map<String, dynamic> res = await AppoimentService.getPendingAppoimentByPatient(ci);


    if(res['ok'] == false) return [];

    final result = res["results"] as List<dynamic>;

    return List<Appoiment>.from(result.map((a) => Appoiment.fromJson(a)));
  } 

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


  Future<Response> newApoiment(Appoiment newAppoiment) async{

    final Map<String, dynamic> data = await AppoimentService.insetAppoiment(newAppoiment);

    final response = Response.fromJson(data);

    if(response.ok){
      final Appoiment succesAppoiment = Appoiment.fromJson(data["result"]);
      
      await NotificationService.showNotification(succesAppoiment.idCita!, succesAppoiment.fechaCita);
    }

    return response;

    //final List list = await NotificationService.notificationsPlugin.pendingNotificationRequests();
  }

  Future<Response> cancelAppoiment(appoimentId) async{
    final Map<String, dynamic> data = await AppoimentService.cancelAppoiment(appoimentId);

    final response = Response.fromJson(data);

    if(response.ok){
      await NotificationService.notificationsPlugin.cancel(appoimentId);
    }

    return response;
  }

  Future<Response> updateAppoiment(appoimentId, patientCi) async{

    final Map<String, dynamic> data = await AppoimentService.insertExistAppoiment(appoimentId, patientCi);

    final response = Response.fromJson(data);

    if(response.ok){
      final Appoiment succesAppoiment = Appoiment.fromJson(data["result"]);

      await NotificationService.showNotification(succesAppoiment.idCita!, succesAppoiment.fechaCita);
    }


    return response;

  }


  void searchAppoimentByDate(date){
    filterAppoiments = appoiments.where((appoiment){
      final dateAppoimentFormat = DateFormat('dd/MM/yyyy').format(appoiment.fechaCita);
      if(dateAppoimentFormat == date){
        return true;
      }
      return false;
    }).toList();

    notifyListeners();
  }


}