

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers{


  static  String formattedHourFromTime(TimeOfDay time){
    final DateTime dateTime = DateTime(0, 0, 0, time.hour, time.minute);
    final String formattedTime = DateFormat('h:mm a').format(dateTime);

    return formattedTime;
  }

  static String transHour(String hour){
    DateTime hora = DateTime.parse("1970-01-01 $hour");
    String horaFormat = DateFormat('h:mm a').format(hora);
    return horaFormat;
  }

  static String parsedDate(String date){
    final DateTime parsedDate = DateFormat('dd/MM/yy').parse(date);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  static String completeDate(String date){
    List<String> dateArray = date.split(' ');
    final String nameDay = dateArray[0];
    final String day = dateArray[1].split('/')[0];
    final DateTime parsedDate = DateFormat('dd/MM/yy').parse(dateArray[1]);
    final String monthName =  DateFormat('MMMM', 'es_ES').format(parsedDate);
    return '$nameDay $day de $monthName';
  }

  static String completeDateFromDateTime(DateTime date){
    final String nameDay = DateFormat('EEEE', 'es_Es').format(date);
    final String monthName = DateFormat('MMMM', 'es_Es').format(date);
    final String day = DateFormat('d').format(date);
    final String year = DateFormat('y').format(date);

    return '$nameDay, $day de $monthName $year';
  }

  static TimeOfDay stringToTime(String time){
    final hour = int.parse(time.split(':')[0]);
    final minute = int.parse(time.split(':')[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  static bool isSameOrAfter(DateTime date){
    final DateTime now = DateTime.now();

    return now.isAfter(date) || (now.year == date.year && now.month == date.month && now.day == date.day);
  }

  static bool compareHours(TimeOfDay time){
    final double now = TimeOfDay.now().hour + TimeOfDay.now().minute/60.0;
    final double target = time.hour + time.minute/60.0;

    return now > target ? true : false;
  }


  static List<String> months(){
    return ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
  }

}