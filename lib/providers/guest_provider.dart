import 'package:flutter/material.dart';
import 'package:higea_app/models/models.dart';
import 'package:higea_app/services/services.dart';


/// @class [GuestProvider]
/// @description Provider que controla los cambios de estado relacionados con los invitados

class GuestProvider extends ChangeNotifier {

  final GlobalKey<FormState> guestForm = GlobalKey<FormState>();
  String guestWithoutCi = '';
  List<Guest> guests = [];
  Guest guestData = Guest();
  int lastDigits = 0;


  Future<List<Guest>> showGuestByPaTient(int ci) async{
    
    final Response data = await GuestService.getGuestsByPatient(ci);

    if(!data.ok) return [];
    
    final List<Guest> guestsResult = List.from(data.result.map((el) => Guest.fromJson(el)));

    guests = guestsResult;
    return guestsResult;
  }


  Future<Response> registerGuest() async{
    final Response data = await GuestService.insertGuest(guestData);
    
    if(data.ok) notifyListeners();
  
    return data;
  }


  Future<Response> editGuest() async{

    final Response data = await GuestService.updateGuest(guestData);
    
    if(data.ok) notifyListeners();
    return data; 
  }

  Future<Response> deleteGuest(String ci) async{
    final Response data = await GuestService.deleteGuest(ci);

    if(data.ok) notifyListeners();
    return data;
  }

  void lastCiGuest(String userCi){

    int lastTwoDigits = 0;
    String patientCi = userCi;
    
    if(guests.isNotEmpty){
      List<Guest> guestFilter = guests.where((guest) => guest.cedula!.length == 10).toList();
      String numStr = guestFilter[guestFilter.length - 1].cedula!;
      patientCi = numStr.substring(0, numStr.length - 2);
      lastTwoDigits = int.parse(numStr.substring(numStr.length - 2));
    }
    lastDigits = lastTwoDigits + 1;

    if(lastDigits != lastTwoDigits){
      guestWithoutCi = patientCi + lastDigits.toString().padLeft(2, '0');
      notifyListeners();
    }
  }

}