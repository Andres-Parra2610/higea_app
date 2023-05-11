import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:higea_app/models/models.dart';
import 'package:http/http.dart' as http;

/// @class [GuestService]
/// @description Servicio que trae los datos del servidor relacionados con los invitados de un usuario o paciente

class GuestService {
  static final server = dotenv.env['SERVER_PATH'];

  static Future getGuestsByPatient(int ci) async {
    final Uri url = Uri.parse('$server/guest/get/$ci');
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    return Response.fromJson(data);
  }

  static Future insertGuest(Guest guest) async{
    final url = Uri.parse('$server/guest/new');
    final response = await http.post(
      url, 
      body: jsonEncode(guest.toJson()),
      headers: {'Content-Type': 'application/json'}
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return Response.fromJson(data);
  }

  static Future updateGuest(Guest guest) async{
    final url = Uri.parse('$server/guest/edit');
    final response = await http.put(
      url,
      body: jsonEncode(guest.toJson()),
      headers: {'Content-Type': 'application/json'}
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return Response.fromJson(data);
  }


  static Future deleteGuest(String ci) async {
    final Uri url = Uri.parse('$server/guest/delete/$ci');
    final response = await http.put(url);
    final data = jsonDecode(response.body);
    return Response.fromJson(data);
  }
}