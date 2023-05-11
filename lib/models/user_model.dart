import 'dart:convert';
import 'package:higea_app/models/models.dart';


/// @class [User]
/// @description Clase cque define el modelo del usuario o paciente que usará la aplicación

class User {
    User({
        required this.cedula,
        required this.nombrePaciente,
        required this.apellidoPaciente,
        required this.correo,
        required this.telefonoPaciente,
        required this.fechaNacimientoPaciente,
        this.activo,
        this.invitados
    });

    final int cedula;
    final DateTime fechaNacimientoPaciente;
    final int? activo;
    String nombrePaciente;
    String apellidoPaciente;
    String correo;
    String telefonoPaciente;
    List<Guest>? invitados;


    User.empty() : 
      cedula = 0,
      nombrePaciente = '',
      apellidoPaciente = '',
      correo = '',
      telefonoPaciente = '',
      fechaNacimientoPaciente = DateTime(0),
      activo = 0;


    factory User.fromRawJson(String str) => User.fromJson(json.decode(str));


    factory User.fromJson(Map<String, dynamic> json) => User(
        cedula: json["cedula_paciente"],
        nombrePaciente: json["nombre_paciente"],
        apellidoPaciente: json["apellido_paciente"],
        correo: json["correo_paciente"],
        telefonoPaciente: json["telefono_paciente"],
        fechaNacimientoPaciente: DateTime.parse(json["fecha_nacimiento_paciente"]),
        activo: json["activo"] ?? 0,
        invitados: json["invitados"]
    );


    Map<String, dynamic> toJson() => {
      'name': nombrePaciente,
      'lastName': apellidoPaciente,
      'email': correo,
      'phone': telefonoPaciente,
    };


}