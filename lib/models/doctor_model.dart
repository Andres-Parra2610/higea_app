import 'dart:convert';

class Doctor {
    Doctor({
        required this.cedula,
        required this.nombreMedico,
        required this.apellidoMedico,
        this.sexoMedico,
        this.horaInicio,
        this.horaFin,
        this.telefonoMedico,
        this.correo, 
        this.fechaNacimiento, 
        this.nombreEspecialidad, 
        this.fechas
    });

    int cedula;
    String nombreMedico;
    String apellidoMedico;
    String? sexoMedico;
    String? horaInicio;
    String? horaFin;
    String? telefonoMedico;
    String? correo;
    DateTime? fechaNacimiento;
    String? nombreEspecialidad;
    List<String>? fechas;

    Doctor.empty() :
      cedula = 0,
      nombreMedico = '',
      apellidoMedico = '',
      sexoMedico = '',
      horaInicio = '',
      correo = '',
      fechaNacimiento = DateTime(0),
      nombreEspecialidad = '',
      fechas = [],
      telefonoMedico = '',
      horaFin = '';

    factory Doctor.fromRawJson(String str) => Doctor.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        cedula: json["cedula_medico"],
        nombreMedico: json["nombre_medico"],
        apellidoMedico: json["apellido_medico"],
        sexoMedico: json["sexo_medico"],
        horaInicio: json["hora_inicio"],
        horaFin: json["hora_fin"],
        telefonoMedico: json["telefono_medico"] ?? '',
        correo: json["correo_medico"] ?? '',
        nombreEspecialidad: json["nombre_especialidad"] ?? '',
        fechaNacimiento: json["fecha_nacimiento"] == null ? DateTime(2000) :  DateTime.parse(json["fecha_nacimiento"]),
        fechas: json["fechas"] == null ? [] : List<String>.from(json["fechas"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "cedula_medico": cedula,
        "nombre_medico": nombreMedico,
        "apellido_medico": apellidoMedico,
        "sexo_medico": sexoMedico,
        "hora_inicio": horaInicio,
        "hora_fin": horaFin,
        "telefono_medico": telefonoMedico,
        "correo_medico": correo,
        "fecha_nacimiento": fechaNacimiento!.toIso8601String(),
        "nombre_especialidad": nombreEspecialidad,
        "fechas": List<dynamic>.from(fechas!.map((x) => x)),
    };
}