import 'dart:convert';

class Doctor {
    Doctor({
        required this.cedulaMedico,
        required this.nombreMedico,
        required this.apellidoMedico,
        required this.sexoMedico,
        required this.horaInicio,
        required this.horaFin,
        this.fechas
    });

    final int cedulaMedico;
    final String nombreMedico;
    final String apellidoMedico;
    final String sexoMedico;
    final String horaInicio;
    final String horaFin;
    final List<String>? fechas;

    factory Doctor.fromRawJson(String str) => Doctor.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        cedulaMedico: json["cedula_medico"],
        nombreMedico: json["nombre_medico"],
        apellidoMedico: json["apellido_medico"],
        sexoMedico: json["sexo_medico"],
        horaInicio: json["hora_inicio"],
        horaFin: json["hora_fin"],
        fechas: json["fechas"] == null ? [] : List<String>.from(json["fechas"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "cedula_medico": cedulaMedico,
        "nombre_medico": nombreMedico,
        "apellido_medico": apellidoMedico,
        "sexo_medico": sexoMedico,
        "hora_inicio": horaInicio,
        "hora_fin": horaFin,
        "fechas": List<dynamic>.from(fechas!.map((x) => x)),
    };
}