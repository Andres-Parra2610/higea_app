import 'dart:convert';

class Doctor {
    Doctor({
        required this.cedulaMedico,
        required this.nombreMedico,
        required this.apellidoMedico,
        required this.sexoMedico,
        required this.idEspecialidad,
    });

    final int cedulaMedico;
    final String nombreMedico;
    final String apellidoMedico;
    final String sexoMedico;
    final int idEspecialidad;

    factory Doctor.fromRawJson(String str) => Doctor.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        cedulaMedico: json["cedula_medico"],
        nombreMedico: json["nombre_medico"],
        apellidoMedico: json["apellido_medico"],
        sexoMedico: json["sexo_medico"],
        idEspecialidad: json["id_especialidad"],
    );

    Map<String, dynamic> toJson() => {
        "cedula_medico": cedulaMedico,
        "nombre_medico": nombreMedico,
        "apellido_medico": apellidoMedico,
        "sexo_medico": sexoMedico,
        "id_especialidad": idEspecialidad,
    };
}