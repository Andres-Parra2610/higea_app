
import 'dart:convert';

class Speciality {
    Speciality({
        required this.idespecialidad,
        required this.nombreEspecialidad,
        this.imagenEspecialidad,
    });

    final int idespecialidad;
    final String nombreEspecialidad;
    final String? imagenEspecialidad;

    factory Speciality.fromRawJson(String str) => Speciality.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Speciality.fromJson(Map<String, dynamic> json) => Speciality(
        idespecialidad: json["idespecialidad"],
        nombreEspecialidad: json["nombre_especialidad"],
        imagenEspecialidad: json["imagen_especialidad"],
    );

    Map<String, dynamic> toJson() => {
        "idespecialidad": idespecialidad,
        "nombre_especialidad": nombreEspecialidad,
        "imagen_especialidad": imagenEspecialidad,
    };
}