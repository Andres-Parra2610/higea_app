
import 'dart:convert';

class DoctorDaysWork {
    DoctorDaysWork({
        required this.cedulaDoctor,
        required this.fechas,
    });

    final int cedulaDoctor;
    final List<String> fechas;

    factory DoctorDaysWork.fromRawJson(String str) => DoctorDaysWork.fromJson(json.decode(str));

    factory DoctorDaysWork.fromJson(Map<String, dynamic> json) => DoctorDaysWork(
        cedulaDoctor: json["cedula_doctor"],
        fechas: List<String>.from(json["fechas"].map((x) => x)),
    );
}