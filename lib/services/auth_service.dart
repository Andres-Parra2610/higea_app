import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthService{

  static final server = dotenv.env['SERVER_PATH'];


  static Future loginUser(String ci, String password) async{

    try {


      final Uri url = Uri.parse('$server/auth/login');

      final Map<String, dynamic> reqBody = {
        'ci': ci,
        'password': password
      };
    
      final response = await http.post(url, body: reqBody);

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      return data;
      
    } catch (e) {
      print('Algo salió mal, $e');
      return null;
    }
  } 


  static Future registerUser(Map<String, dynamic> userData) async{

    final url = Uri.parse('$server/auth/register-user');
    final response = await http.post(url, body: userData);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }

  static Future confirmEmail(Map<String, dynamic> userData) async{

    final url = Uri.parse('$server/auth/verify-code');
    final response = await http.post(url, body: userData);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }

  static Future getUser(String ci) async{
    final url = Uri.parse('$server/recovery-password/user/$ci');
    final response = await http.get(url);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }

  static Future codeVerification(String code) async{
    final url = Uri.parse('$server/recovery-password/code');
    final Map<String, dynamic> reqBody = {'codeVerification': code};
    final response = await http.post(url, body: reqBody);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }

  static Future updatePassword(Map<String, dynamic> reqBody) async{
    final url = Uri.parse('$server/recovery-password/new-password');
    final response = await http.put(url, body: jsonEncode(reqBody), headers: {'Content-Type': 'application/json'});
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }
}