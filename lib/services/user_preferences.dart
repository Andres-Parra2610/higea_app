
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences{

  static late SharedPreferences _prefers;
  static String _user = '';
  static int _idRol = 0;


  static Future initPreferences() async{
    _prefers = await SharedPreferences.getInstance();
  }

  static String get user => _prefers.getString('user') ?? _user;
  static int get idRol => _prefers.getInt('idRol') ?? _idRol;

  static set setUser(String user){
    _user = user;
    _prefers.setString('user', user);
  }

  static set setIdRol(int value){
    _idRol = value;
    _prefers.setInt('idRol', value);
  }

  static Future deleteUser() async{
    _user = '';
    _idRol = 0;
    await _prefers.remove('user');
    await _prefers.remove('idRol');
  }
}