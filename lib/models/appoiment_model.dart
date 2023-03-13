import 'dart:convert';

class Appoiment {
    Appoiment({
        required this.cedulaMedico,
        required this.fechaCita,
        required this.horaCita,
        this.citaEstado,
        this.cedulaPaciente
    });

    final int cedulaMedico;
    final DateTime fechaCita;
    final String horaCita;
    String? citaEstado;
    int? cedulaPaciente;

    factory Appoiment.fromRawJson(String str) => Appoiment.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Appoiment.fromJson(Map<String, dynamic> json) => Appoiment(
        cedulaMedico: json["cedula_medico"],
        cedulaPaciente: json["cedula_paciente"] ?? 0,
        fechaCita: DateTime.parse(json["fecha_cita"]),
        horaCita: json["hora_cita"],
        citaEstado: json["cita_estado"] ?? ' ',
    );

    Map<String, dynamic> toJson() => {
        "doctorCi": cedulaMedico.toString(),
        "patientCi": cedulaPaciente.toString(),
        "appoimentDate": "${fechaCita.year.toString().padLeft(4, '0')}-${fechaCita.month.toString().padLeft(2, '0')}-${fechaCita.day.toString().padLeft(2, '0')}",
        "appoimentHour": horaCita,
        "cita_estado": citaEstado,
    };
}