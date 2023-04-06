

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

  static String transformHour(String hour){

    String modifiedDate = hour;
    String format = 'am';
    
    if(modifiedDate.startsWith('0')){
      modifiedDate = hour.substring(1);
    }

    int dateNumber= int.parse(modifiedDate.substring(0, modifiedDate.length - 6));

    if(dateNumber > 12){
      dateNumber = dateNumber - 12;
      format = 'pm';
    }

    modifiedDate = "$dateNumber:00 $format";

    return modifiedDate;
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


  static List<String> months(){
    return ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
  }

}