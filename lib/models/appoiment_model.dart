import 'dart:convert';

import 'package:higea_app/models/models.dart';

class Appoiment {
    Appoiment({
        required this.cedulaMedico,
        required this.fechaCita,
        required this.horaCita,
        this.user,
        this.doctor,
        this.citaEstado,
        this.idCita,
        this.cedulaPaciente
    });

    final int cedulaMedico;
    final DateTime fechaCita;
    final String horaCita;
    final int? idCita;
    final User? user;
    final Doctor? doctor;
    String? citaEstado;
    int? cedulaPaciente;

    factory Appoiment.fromRawJson(String str) => Appoiment.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Appoiment.fromJson(Map<String, dynamic> json) => Appoiment(
        idCita: json["id_cita"] ?? 0,
        cedulaMedico: json["cedula_medico"],
        cedulaPaciente: json["cedula_paciente"] ?? 0,
        fechaCita: DateTime.parse(json["fecha_cita"]),
        horaCita: json["hora_cita"],
        citaEstado: json["cita_estado"] ?? ' ',
        user:  json["paciente"] == null ? User.empty() : User.fromJson(json["paciente"]), 
        doctor: json["doctor"] == null ? Doctor.empty() : Doctor.fromJson(json["doctor"]) 
    );

    Map<String, dynamic> toJson() => {
        "idCita": idCita.toString(),
        "doctorCi": cedulaMedico.toString(),
        "patientCi": cedulaPaciente.toString(),
        "appoimentDate": "${fechaCita.year.toString().padLeft(4, '0')}-${fechaCita.month.toString().padLeft(2, '0')}-${fechaCita.day.toString().padLeft(2, '0')}",
        "appoimentHour": horaCita,
        "cita_estado": citaEstado,
    };
}