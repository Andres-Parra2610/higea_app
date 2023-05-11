

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


/// Clase de ayuda para colocar algunos métodos usados en toda la aplicación

class Helpers{

  /// @method [formattedHourFromTime]
  /// @param [TimeOfday: time]
  /// @description Convierte una variable de tipo TimeOfDay en una de tipo String
  static  String formattedHourFromTime(TimeOfDay time){
    final DateTime dateTime = DateTime(0, 0, 0, time.hour, time.minute);
    final String formattedTime = DateFormat('h:mm a').format(dateTime);

    return formattedTime;
  }

  /// @method [transHour]
  /// @param [String: hour]
  /// @description Convierte la hora en un formato legible horas y minutoa
  static String transHour(String hour){
    DateTime hora = DateTime.parse("1970-01-01 $hour");
    String horaFormat = DateFormat('h:mm a').format(hora);
    return horaFormat;
  }

  /// @method [parsetDate]
  /// @param [String: date]
  /// @description Convierte una fecha de tipo String en una de tipo DateTime
  static String parsedDate(String date){
    final DateTime parsedDate = DateFormat('dd/MM/yy').parse(date);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }


  /// @method [completeDate]
  /// @param [String: date]
  /// @description Convierte un día específico a un formato legible tipo nombre del día (Lunes, martes..) el día y el nombre del mes
  static String completeDate(String date){
    List<String> dateArray = date.split(' ');
    final String nameDay = dateArray[0];
    final String day = dateArray[1].split('/')[0];
    final DateTime parsedDate = DateFormat('dd/MM/yy').parse(dateArray[1]);
    final String monthName =  DateFormat('MMMM', 'es_ES').format(parsedDate);
    return '$nameDay $day de $monthName';
  }

  /// @method [completeDateFromDateTime]
  /// @param [DateTime: date]
  /// @description Convierte una fecha de tipo DateTime en una de tipo String
  static String completeDateFromDateTime(DateTime date){
    final String nameDay = DateFormat('EEEE', 'es_Es').format(date);
    final String monthName = DateFormat('MMMM', 'es_Es').format(date);
    final String day = DateFormat('d').format(date);
    final String year = DateFormat('y').format(date);

    return '$nameDay, $day de $monthName $year';
  }


  /// @method [stringToTime]
  /// @param [String: time]
  /// @description Convierte una hora en formato String a una de formato TimeOfDay
  static TimeOfDay stringToTime(String time){
    final hour = int.parse(time.split(':')[0]);
    final minute = int.parse(time.split(':')[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  /// @method [isSameOrAfter]
  /// @param [DateTime: date]
  /// @description Compara la hora actual y la hora enviada por parámetro para conocer si la fecha es el mismo día o despues
  static bool isSameOrAfter(DateTime date){
    final DateTime now = DateTime.now();

    return now.isAfter(date) || (now.year == date.year && now.month == date.month && now.day == date.day);
  }

  /// @method [compareHours]
  /// @param [TimeOfDay: time]
  /// @description Compara dos horas para conocer la hora actual es mayot a la hora enviada
  static bool compareHours(TimeOfDay time){
    final double now = TimeOfDay.now().hour + TimeOfDay.now().minute/60.0;
    final double target = time.hour + time.minute/60.0;

    return now > target ? true : false;
  }


  /// @method [months]
  /// @description Retorna una lista con los nombres de los meses
  static List<String> months(){
    return ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
  }

}