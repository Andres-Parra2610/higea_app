import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DoctorServices {

  static final server = dotenv.env['SERVER_PATH'];


  static Future getAllSpecialities() async{
    final url = Uri.parse('$server/speciality');
    final response = await http.get(url);
    final data =  jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }

  static Future getDoctorBySpeciality(id) async{
    
    final url = Uri.http("192.168.1.101:3001", '/speciality/doctors', {
      'id': '$id'
    });

    final response = await http.get(url);
    final data =  jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }

  static Future getDoctorDatesWork(ci) async {

    final url = Uri.parse('$server/speciality/doctor/$ci');
    final response = await http.get(url);
    final data =  jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }

}