import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:higea_app/models/models.dart';

class AppoimentService {

  static final server = dotenv.env['SERVER_PATH'];
  static final port = dotenv.env['SERVER_PORT']!;

  static Future getAppoiments(doctorCi, [date = '']) async{

    final url = Uri.http(port, '/appoiment/$doctorCi', {
      'date': '$date'
    });
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
  
  static Future cancelAppoiment(appoimentId) async{
    final url = Uri.parse('$server/appoiment/cancel/$appoimentId');
    final response = await http.put(url);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }

  static Future insertExistAppoiment(appoimentId, patientCi) async{
    final url = Uri.parse('$server/appoiment/update/$appoimentId/$patientCi');
    final response = await http.put(url);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }

  static Future getHistoryById([id = 0]) async{
    final url = Uri.http(port, '/appoiment/history', {
      'id': '$id'
    });
    final response = await http.get(url);
    final data =  jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }

  static Future setHistory(History history, int appoimentId) async{
    final url = Uri.parse('$server/appoiment/finish/$appoimentId');
    final response = await http.put(url, body: jsonEncode(history), headers: {'Content-Type': 'application/json'});
    final data =  jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }

  static Future getAllAppoiments() async{
    final url = Uri.parse('$server/appoiment/all');
    final response = await http.get(url);
    final data =  jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }

  static Future getPendingAppoimentByPatient(int ci) async{
    final url = Uri.parse('$server/appoiment/patient/$ci');
    final response = await http.get(url);
    final data =  jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }
}