import 'dart:convert';

class Appoiment {
    Appoiment({
        required this.cedulaMedico,
        required this.fechaCita,
        required this.horaCita,
        required this.citaEstado,
    });

    final int cedulaMedico;
    final DateTime fechaCita;
    final String horaCita;
    final String citaEstado;

    factory Appoiment.fromRawJson(String str) => Appoiment.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Appoiment.fromJson(Map<String, dynamic> json) => Appoiment(
        cedulaMedico: json["cedula_medico"],
        fechaCita: DateTime.parse(json["fecha_cita"]),
        horaCita: json["hora_cita"],
        citaEstado: json["cita_estado"],
    );

    Map<String, dynamic> toJson() => {
        "cedula_medico": cedulaMedico,
        "fecha_cita": "${fechaCita.year.toString().padLeft(4, '0')}-${fechaCita.month.toString().padLeft(2, '0')}-${fechaCita.day.toString().padLeft(2, '0')}",
        "hora_cita": horaCita,
        "cita_estado": citaEstado,
    };
}