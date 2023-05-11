
import 'dart:convert';


/// @class [Admin]
/// @description Clase cque define el modelo del administrador

class Admin{

  Admin({
    required this.cedula,
    required this.nombreAdmin,
    required this.apellidoAdmin,
    required this.correo
  });

  final int cedula;
  final String nombreAdmin;
  final String apellidoAdmin;
  final String correo;


  factory Admin.fromRawJson(String str) => Admin.fromJson(json.decode(str));

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
    cedula: json['cedula_admin'],
    nombreAdmin: json['nombre_admin'],
    apellidoAdmin: json['apellido_admin'],
    correo: json['correo_admin'],
  );
}