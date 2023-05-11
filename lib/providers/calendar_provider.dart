import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/services/services.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';


/// @class [CalendarProvider]
/// @description Provider que controla los cambios de estado relacionados con el calendario que visualiza un médico de la aplicación

class CalendarProvider extends ChangeNotifier{

  ValueNotifier<List<Appoiment>> selectedAppoiments = ValueNotifier([]);
  final DateFormat format = DateFormat('yyyy-MM-dd');
  Map<String, List<Appoiment>> events = {};
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime dayFocused = DateTime.now();
  DateTime currentDay = DateTime.now();


  Future<Map<String, List<Appoiment>>> getEventsFromBd(doctorCi, [bool reload = false]) async{

    if(reload == true){
      final Map<String, dynamic> res = await AppoimentService.getAppoiments(doctorCi);

      events = Map.from(res['results']).map((k, v) => MapEntry<String, List<Appoiment>>(k, List<Appoiment>.from(v.map((x) => Appoiment.fromJson(x)))));

      selectedAppoiments = ValueNotifier<List<Appoiment>>(_getTodayEvents(currentDay));
    }else if(events.isNotEmpty){
      return events;
    }
    return events;
  }

  List<Appoiment> getAllEvents(DateTime date){
    final formatDate = format.format(date); 
    return events[formatDate] ?? [];
  }


  List<Appoiment> _getTodayEvents(DateTime date){
    final formatDate = format.format(date);
    return events[formatDate] ?? [];
  }

  void onSelectDay(DateTime selectedDay, DateTime focusedDay){
    if(!isSameDay(selectedDay, currentDay)){
      currentDay = selectedDay;
      dayFocused = focusedDay;
      notifyListeners();
      selectedAppoiments.value = _getTodayEvents(currentDay);
    }
  }
}