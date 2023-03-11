

import 'package:intl/intl.dart';

class Helpers{

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

}