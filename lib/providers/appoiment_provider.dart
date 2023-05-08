import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:higea_app/helpers/helpers.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/services/services.dart';
import 'package:intl/intl.dart';

class AppoimentProvider extends ChangeNotifier{

  final GlobalKey<FormState> confirmAppoimentForm = GlobalKey<FormState>();
  List<Appoiment> appoiments = [];
  List<Appoiment> filterAppoiments = [];
  List<Appoiment> pendingAppoiment = [];
  String selectedGuest = '';
  bool loading = false;
  String date = '';
  bool _insertAppoiment = true;


  Future getAllAppoiments() async{
    final Map<String, dynamic> data = await AppoimentService.getAllAppoiments();
    final result = data['result'] as List<dynamic>;
    
    appoiments = List<Appoiment>.from(result.map((a) => Appoiment.fromJson(a)));
    filterAppoiments = appoiments;

    notifyListeners();
  }

  Future<List<Appoiment>> showAppoimentByPatient(int ci) async{

    if(pendingAppoiment.isNotEmpty && !_insertAppoiment) return pendingAppoiment;

    final Map<String, dynamic> data = await AppoimentService.getPendingAppoimentByPatient(ci);

    if(data['ok'] == false) return [];

    final result = data['result'] as List<dynamic>;

    pendingAppoiment = List<Appoiment>.from(result.map((a) => Appoiment.fromJson(a)));
    _insertAppoiment = false;
    return pendingAppoiment;
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

    final result = res['results'] as List<dynamic>;
    
    appoiments = List<Appoiment>.from(result.map((a) => Appoiment.fromJson(a)));

    date = completeDate;
    loading = false;
    notifyListeners();
  }


  Future newApoiment(Appoiment newAppoiment) async{

    Map<String, dynamic> data; 

    selectedGuest != newAppoiment.cedulaPaciente.toString() 
      ? newAppoiment.cedulaInvitado = selectedGuest
      : newAppoiment.cedulaInvitado = null;

    newAppoiment.idCita == 0
      ? data = await AppoimentService.insertAppoiment(newAppoiment)
      : data = await AppoimentService.insertExistAppoiment(newAppoiment);
    

    final response = Response.fromJson(data);

    if(response.ok){
      final Appoiment succesAppoiment = Appoiment.fromJson(response.result);
      
      await NotificationService.showNotification(succesAppoiment.idCita!, succesAppoiment.fechaCita);
    }

    final List<PendingNotificationRequest> list = await NotificationService.notificationsPlugin.pendingNotificationRequests();

    for (var notification in list) {
      print(notification.id);
    }

    _insertAppoiment = true;
    return response; 

  }


  Future<Response> cancelAppoiment(appoimentId) async{
    final Map<String, dynamic> data = await AppoimentService.cancelAppoiment(appoimentId);

    final response = Response.fromJson(data);

    if(response.ok){
      await NotificationService.notificationsPlugin.cancel(appoimentId);
    }

    return response;
  }



  void onChangeGuest(String? value){
    selectedGuest = value!;
    notifyListeners();
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

  void closeSession(){
    appoiments = [];
    pendingAppoiment = [];
    filterAppoiments = [];
    selectedGuest = '';
    date = '';
  }


}