import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PatientService{

  static final server = dotenv.env['SERVER_PATH'];

  static Future getAllPatient() async{
    final url = Uri.parse('$server/patient/all');
    final response = await http.get(url);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  } 
}