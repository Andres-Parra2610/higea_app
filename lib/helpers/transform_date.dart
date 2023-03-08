

class TransForm{

  static String transformDate(String date){

    String modifiedDate = date;
    String format = 'am';
    
    if(modifiedDate.startsWith('0')){
      modifiedDate = date.substring(1);
    }

    int dateNumber= int.parse(modifiedDate.substring(0, modifiedDate.length - 6));

    if(dateNumber > 12){
      dateNumber = dateNumber - 12;
      format = 'pm';
    }

    modifiedDate = "$dateNumber:00 $format";

    return modifiedDate;
  }
}