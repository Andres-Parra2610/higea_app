
import 'dart:convert';

class Admin{

  Admin({
    required this.cedulaAdmin,
    required this.nombreAdmin,
    required this.apellidoAdmin,
    required this.correoAdmin
  });

  final int cedulaAdmin;
  final String nombreAdmin;
  final String apellidoAdmin;
  final String correoAdmin;


  factory Admin.fromRawJson(String str) => Admin.fromJson(json.decode(str));

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
    cedulaAdmin: json['cedula_admin'],
    nombreAdmin: json['nombre_admin'],
    apellidoAdmin: json['apellido_admin'],
    correoAdmin: json['correo_admin'],
  );
}