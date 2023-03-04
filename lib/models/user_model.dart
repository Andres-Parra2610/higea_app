import 'dart:convert';

class User {
    User({
        required this.idpaciente,
        required this.nombrePaciente,
        required this.apellidoPaciente,
        required this.correoPaciente,
        required this.telefonoPaciente,
        required this.fechaNacimientoPaciente,
        this.activo,
        this.idRol,
    });

    final int idpaciente;
    final String nombrePaciente;
    final String apellidoPaciente;
    final String correoPaciente;
    final String telefonoPaciente;
    final DateTime fechaNacimientoPaciente;
    final int? activo;
    final int? idRol;

    factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory User.fromJson(Map<String, dynamic> json) => User(
        idpaciente: json["idpaciente"],
        nombrePaciente: json["nombre_paciente"],
        apellidoPaciente: json["apellido_paciente"],
        correoPaciente: json["correo_paciente"],
        telefonoPaciente: json["telefono_paciente"],
        fechaNacimientoPaciente: DateTime.parse(json["fecha_nacimiento_paciente"]),
        activo: json["activo"],
        idRol: json["id_rol"],
    );

    Map<String, dynamic> toJson() => {
        "idpaciente": idpaciente,
        "nombre_paciente": nombrePaciente,
        "apellido_paciente": apellidoPaciente,
        "correo_paciente": correoPaciente,
        "telefono_paciente": telefonoPaciente,
        "fecha_nacimiento_paciente": fechaNacimientoPaciente.toIso8601String(),
        "activo": activo,
        "id_rol": idRol,
    };
}