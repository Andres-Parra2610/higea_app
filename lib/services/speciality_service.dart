import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:higea_app/models/models.dart';
import 'package:http/http.dart' as http;

class SpecialityService {
  static final server = dotenv.env['SERVER_PATH'];

  static Future addSpeciality(Speciality speciality) async{
    final url = Uri.parse('$server/speciality/new');
    final response = await http.post(url, body: jsonEncode(speciality), headers: {'Content-Type': 'application/json'});
    final data =  jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }
}