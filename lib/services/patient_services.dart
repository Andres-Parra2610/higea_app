import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:higea_app/models/models.dart';
import 'package:http/http.dart' as http;

class PatientService{

  static final server = dotenv.env['SERVER_PATH'];

  static Future getAllPatient() async{
    final url = Uri.parse('$server/patient/all');
    final response = await http.get(url);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  } 


  static Future editPatient(int ci, User body) async{
    final url = Uri.parse('$server/patient/edit/$ci');
    final response = await http.put(
      url,
      body: jsonEncode(body.toJson()),
      headers: {'Content-Type': 'application/json'}
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return Response.fromJson(data);
  }
}