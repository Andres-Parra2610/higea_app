import 'dart:convert';

class User {
    User({
        required this.cedula,
        required this.nombrePaciente,
        required this.apellidoPaciente,
        required this.correo,
        required this.telefonoPaciente,
        required this.fechaNacimientoPaciente,
        this.activo,
    });

    final int cedula;
    final String nombrePaciente;
    final String apellidoPaciente;
    final String correo;
    final String telefonoPaciente;
    final DateTime fechaNacimientoPaciente;
    final int? activo;


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
    );


}