import 'dart:convert';

class User {
    User({
        required this.cedulaPaciente,
        required this.nombrePaciente,
        required this.apellidoPaciente,
        required this.correoPaciente,
        required this.telefonoPaciente,
        required this.fechaNacimientoPaciente,
        this.activo,
    });

    final int cedulaPaciente;
    final String nombrePaciente;
    final String apellidoPaciente;
    final String correoPaciente;
    final String telefonoPaciente;
    final DateTime fechaNacimientoPaciente;
    final int? activo;

    factory User.fromRawJson(String str) => User.fromJson(json.decode(str));


    factory User.fromJson(Map<String, dynamic> json) => User(
        cedulaPaciente: json["cedula_paciente"],
        nombrePaciente: json["nombre_paciente"],
        apellidoPaciente: json["apellido_paciente"],
        correoPaciente: json["correo_paciente"],
        telefonoPaciente: json["telefono_paciente"],
        fechaNacimientoPaciente: DateTime.parse(json["fecha_nacimiento_paciente"]),
        activo: json["activo"],
    );


}