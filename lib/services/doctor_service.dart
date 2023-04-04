import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:higea_app/models/models.dart';
import 'package:http/http.dart' as http;

class DoctorServices {

  static final server = dotenv.env['SERVER_PATH'];
  static final port = dotenv.env['SERVER_PORT']!;


  static Future getAllSpecialities() async{
    final url = Uri.parse('$server/speciality');
    final response = await http.get(url);
    final data =  jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }

  static Future getDoctorBySpeciality(id) async{
    
    final url = Uri.http(port, '/speciality/doctors', {
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

  static Future getAllDoctors() async {
    final url = Uri.parse('$server/doctor/all');
    final response = await http.get(url);
    final data =  jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }

  static Future registerDoctor(Doctor doctor) async {
    final url = Uri.parse('$server/doctor/new');
    final response = await http.post(url, body: jsonEncode(doctor.toJson()), headers: {'Content-Type': 'application/json'});
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }

  static Future editDoctor(Doctor doctor) async {
    final url = Uri.parse('$server/doctor/edit');
    final response = await http.put(url, body: jsonEncode(doctor.toJson()), headers: {'Content-Type': 'application/json'});
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }

   static Future removeDoctor(int doctorCi) async {
    final url = Uri.parse('$server/doctor/delete/$doctorCi');
    final response = await http.put(url);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }

}