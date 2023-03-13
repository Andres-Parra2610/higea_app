import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:higea_app/models/models.dart';

class AppoimentService {

  static final server = dotenv.env['SERVER_PATH'];


  static Future getAppoiments(doctorCi, date) async{
    final url = Uri.parse('$server/appoiment/$doctorCi/$date');
    final response = await http.get(url);
    final data =  jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }


  static Future insetAppoiment(Appoiment appoiment) async{

    final url = Uri.parse('$server/appoiment/new');
    final response = await http.post(url, body: appoiment.toJson());
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }
  
}