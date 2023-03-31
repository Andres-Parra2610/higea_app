import 'dart:convert';

class Doctor {
    Doctor({
        required this.cedulaMedico,
        required this.nombreMedico,
        required this.apellidoMedico,
        required this.sexoMedico,
        required this.horaInicio,
        required this.horaFin,
        this.telefonoMedico,
        this.correoMedico, 
        this.fechaNacimiento, 
        this.nombreEspecialidad, 
        this.fechas
    });

    int cedulaMedico;
    String nombreMedico;
    String apellidoMedico;
    String sexoMedico;
    String horaInicio;
    String horaFin;
    String? telefonoMedico;
    String? correoMedico;
    DateTime? fechaNacimiento;
    String? nombreEspecialidad;
    List<String>? fechas;

    Doctor.empty() :
      cedulaMedico = 0,
      nombreMedico = '',
      apellidoMedico = '',
      sexoMedico = '',
      horaInicio = '',
      correoMedico = '',
      fechaNacimiento = DateTime(0),
      nombreEspecialidad = '',
      fechas = [],
      telefonoMedico = '',
      horaFin = '';

    factory Doctor.fromRawJson(String str) => Doctor.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        cedulaMedico: json["cedula_medico"],
        nombreMedico: json["nombre_medico"],
        apellidoMedico: json["apellido_medico"],
        sexoMedico: json["sexo_medico"],
        horaInicio: json["hora_inicio"],
        horaFin: json["hora_fin"],
        telefonoMedico: json["telefono_medico"] ?? '',
        correoMedico: json["correo_medico"] ?? '',
        nombreEspecialidad: json["nombre_especialidad"] ?? '',
        fechaNacimiento: json["fecha_nacimiento"] == null ? DateTime(2000) :  DateTime.parse(json["fecha_nacimiento"]),
        fechas: json["fechas"] == null ? [] : List<String>.from(json["fechas"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "cedula_medico": cedulaMedico,
        "nombre_medico": nombreMedico,
        "apellido_medico": apellidoMedico,
        "sexo_medico": sexoMedico,
        "hora_inicio": horaInicio,
        "hora_fin": horaFin,
        "telefono_medico": telefonoMedico,
        "correo_medico": correoMedico,
        "fecha_nacimiento": fechaNacimiento,
        "nombre_especialidad": nombreEspecialidad,
        "fechas": List<dynamic>.from(fechas!.map((x) => x)),
    };
}