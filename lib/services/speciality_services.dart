import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SpecialityServices {

  static final server = dotenv.env['SERVER_PATH'];


  static Future getAllSpecialities() async{

    final url = Uri.parse('$server/speciality');
    final response = await http.get(url);
    final data =  jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }

  static Future getDoctorBySpeciality(id) async{
    
    final url = Uri.http("192.168.1.100:3001", '/speciality/doctors', {
      'id': '$id'
    });

    final response = await http.get(url);
    final data =  jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }

}