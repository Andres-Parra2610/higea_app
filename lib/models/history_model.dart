

import 'dart:convert';

class History {
    History({
        this.idhistorial,
        this.notaMedica,
        this.observaciones,
    });

    final int? idhistorial;
    String? notaMedica;
    String? observaciones;

    factory History.fromRawJson(String str) => History.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory History.fromJson(Map<String, dynamic> json) => History(
        idhistorial: json["idhistorial"] ?? 0,
        notaMedica: json["nota_medica"] ?? '',
        observaciones: json["observaciones"] ?? '',
    );

    Map<String, dynamic> toJson() => {
      "historyId": idhistorial,
      "note": notaMedica,
      "observation": observaciones,
    };
}