import 'dart:convert';

class Doctor {
    Doctor({
        required this.cedulaMedico,
        required this.nombreMedico,
        required this.apellidoMedico,
        required this.sexoMedico,
        required this.idEspecialidad,
        required this.horaInicio,
        required this.horaFin
    });

    final int cedulaMedico;
    final String nombreMedico;
    final String apellidoMedico;
    final String sexoMedico;
    final int idEspecialidad;
    final String horaInicio;
    final String horaFin;

    factory Doctor.fromRawJson(String str) => Doctor.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        cedulaMedico: json["cedula_medico"],
        nombreMedico: json["nombre_medico"],
        apellidoMedico: json["apellido_medico"],
        sexoMedico: json["sexo_medico"],
        idEspecialidad: json["id_especialidad"],
        horaInicio: json["hora_inicio"],
        horaFin: json["hora_fin"],
    );

    Map<String, dynamic> toJson() => {
        "cedula_medico": cedulaMedico,
        "nombre_medico": nombreMedico,
        "apellido_medico": apellidoMedico,
        "sexo_medico": sexoMedico,
        "id_especialidad": idEspecialidad,
        "hora_inicio": horaInicio,
        "hora_fin": horaFin
    };
}