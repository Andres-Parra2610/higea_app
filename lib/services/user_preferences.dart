
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences{

  static late SharedPreferences _prefers;
  static String _user = '';


  static Future initPreferences() async{
    _prefers = await SharedPreferences.getInstance();
  }

  static String get user => _prefers.getString('user') ?? _user;

  static set setUser(String user){
    _user = user;
    _prefers.setString('user', user);
  }

  static Future deleteUser() async{
    _user = '';
    await _prefers.remove('user');
  }
}