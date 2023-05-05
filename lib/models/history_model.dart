

import 'dart:convert';

import 'package:higea_app/helpers/helpers.dart';

class History {
    History({
        this.idhistorial,
        this.fechaCita,
        this.horaCita,
        this.nombrePaciente,
        this.apellidoPaciente,
        this.nombreMedico,
        this.apellidoMedico,
        this.cedulaInvitado,
        this.nombreInvitado,
        this.apellidoInvitado,
        this.nombreEspecialidad,
        this.notaMedica,
        this.observaciones,
    });

    final int? idhistorial;
    final DateTime? fechaCita;
    final String? horaCita;
    final String? nombrePaciente;
    final String? apellidoPaciente;
    final String? nombreMedico;
    final String? apellidoMedico;
    final String? cedulaInvitado;
    final String? nombreEspecialidad;
    final String? nombreInvitado;
    final String? apellidoInvitado;
    String? notaMedica;
    String? observaciones;

    get fechaCitaStr => fechaCita == null ? null : Helpers.completeDateFromDateTime(fechaCita!);
    get horaCitaStr => horaCita == null ? null : Helpers.transHour(horaCita!);

    factory History.fromRawJson(String str) => History.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory History.fromJson(Map<String, dynamic> json) => History(
        idhistorial: json["idhistorial"],
        fechaCita: json["fecha_cita"] == null ? null : DateTime.parse(json["fecha_cita"]),
        horaCita: json["hora_cita"],
        nombrePaciente: json["nombre_paciente"],
        apellidoPaciente: json["apellido_paciente"],
        nombreMedico: json["nombre_medico"],
        cedulaInvitado: json["cedula_invitado"],
        nombreInvitado: json["nombre_invitado"],
        apellidoInvitado: json["apellido_invitado"],
        apellidoMedico: json["apellido_medico"],
        nombreEspecialidad: json["nombre_especialidad"],
        notaMedica: json["nota_medica"],
        observaciones: json["observaciones"],
    );

    Map<String, dynamic> toJson() => {
      "historyId": idhistorial,
      "note": notaMedica,
      "observation": observaciones,
    };
}