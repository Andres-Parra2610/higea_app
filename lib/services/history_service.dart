import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// @class [HistoryService]
/// @description Servicio que trae los datos del servidor relacionados con las historias médicas

class HistoryService {
  static final server = dotenv.env['SERVER_PATH'];

  static Future getHistoryByPatient(int ci) async {
    final Uri url = Uri.parse('$server/history/patient/$ci');
    final response = await http.get(url);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }
}