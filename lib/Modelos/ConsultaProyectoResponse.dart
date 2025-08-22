import 'dart:convert';

ConsultaProyectoResponse ConsultaProyectoResponseFromJson(String str) => ConsultaProyectoResponse.fromJson(json.decode(str));

String ConsultaProyectoResponseToJson(ConsultaProyectoResponse data) => json.encode(data.toJson());

class ConsultaProyectoResponse {
  final String message;
  final String projectID;
  final String cedulaCatastral;
  final DateTime fechaHoraConsulta;

  ConsultaProyectoResponse({
    required this.message,
    required this.projectID,
    required this.cedulaCatastral,
    required this.fechaHoraConsulta,
  });

  factory ConsultaProyectoResponse.fromJson(Map<String, dynamic> json) => ConsultaProyectoResponse(
    message: json["message"],
    projectID: json["projectID"],
    cedulaCatastral: json["cedula_catastral"],
    fechaHoraConsulta: DateTime.parse(json["fecha_hora_consulta"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "projectID": projectID,
    "cedula_catastral": cedulaCatastral,
    "fecha_hora_consulta": fechaHoraConsulta.toIso8601String(),
  };
}