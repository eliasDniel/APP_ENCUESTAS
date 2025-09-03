class EncuestasResponse {
  final List<EncuestaResult> results;
  final int total;
  final int page;
  final int limit;

  EncuestasResponse({
    required this.results,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory EncuestasResponse.fromJson(Map<String, dynamic> json) =>
      EncuestasResponse(
        results: List<EncuestaResult>.from(
          json["results"].map((x) => EncuestaResult.fromJson(x)),
        ),
        total: json["total"],
        page: json["page"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "total": total,
    "page": page,
    "limit": limit,
  };
}

class EncuestaResult {
  final int id;
  final String titulo;
  final String descripcion;
  final String creadaPor;
  final DateTime fechaCreacion;
  final int cantidadPreguntas;
  final String estado;

  EncuestaResult({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.creadaPor,
    required this.fechaCreacion,
    required this.cantidadPreguntas,
    required this.estado,
  });

  factory EncuestaResult.fromJson(Map<String, dynamic> json) => EncuestaResult(
    id: json["id"],
    titulo: json["titulo"],
    descripcion: json["descripcion"],
    creadaPor: json["creada_por"],
    fechaCreacion: DateTime.parse(json["fecha_creacion"]),
    cantidadPreguntas: json["cantidad_preguntas"],
    estado: json["estado"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "titulo": titulo,
    "descripcion": descripcion,
    "creada_por": creadaPor,
    "fecha_creacion": fechaCreacion.toIso8601String(),
    "cantidad_preguntas": cantidadPreguntas,
    "estado": estado,
  };
}
