import 'dart:convert';


/// @class [Guest]
/// @description Clase cque define el modelo del invitado

class Guest {
  Guest({
      this.cedula,
      this.nombreInvitado,
      this.apellidoInvitado,
      this.fechaNacimiento,
      this.paciente
    });

  String? cedula;
  String? nombreInvitado;
  String? apellidoInvitado;
  String? fechaNacimiento;
  int? paciente;

  factory Guest.fromRawJson(String str) => Guest.fromJson(json.decode(str));

  factory Guest.fromJson(Map<String, dynamic> json) => Guest(
      cedula: json["cedula_invitado"],
      nombreInvitado: json["nombre_invitado"],
      apellidoInvitado: json["apellido_invitado"],
      fechaNacimiento: json["fecha_nacimiento"],
      paciente: json["paciente"],
  );

  Map<String, dynamic> toJson() => {
    "ci": cedula,
    "name": nombreInvitado,
    "lastName": apellidoInvitado,
    "birthDate": fechaNacimiento,
    "patient": paciente
  };
}
