class EncuestaDetalleResponse {
  final int id;
  final String titulo;
  final String descripcion;
  final List<PreguntaResponse> preguntas;
  final String estado;

  EncuestaDetalleResponse({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.preguntas,
    required this.estado,
  });

  factory EncuestaDetalleResponse.fromJson(Map<String, dynamic> json) =>
      EncuestaDetalleResponse(
        id: json["id"],
        titulo: json["titulo"],
        descripcion: json["descripcion"],
        preguntas: List<PreguntaResponse>.from(
          json["preguntas"].map((x) => PreguntaResponse.fromJson(x)),
        ),
        estado: json["estado"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "titulo": titulo,
    "descripcion": descripcion,
    "preguntas": List<dynamic>.from(preguntas.map((x) => x.toJson())),
    "estado": estado,
  };
}

class PreguntaResponse {
  final int id;
  final String texto;
  final String tipo;
  final List<OpcioneResponse> opciones;

  PreguntaResponse({
    required this.id,
    required this.texto,
    required this.tipo,
    required this.opciones,
  });

  factory PreguntaResponse.fromJson(Map<String, dynamic> json) =>
      PreguntaResponse(
        id: json["id"],
        texto: json["texto"],
        tipo: json["tipo"],
        opciones: List<OpcioneResponse>.from(
          json["opciones"].map((x) => OpcioneResponse.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "texto": texto,
    "tipo": tipo,
    "opciones": List<dynamic>.from(opciones.map((x) => x.toJson())),
  };
}

class OpcioneResponse {
  final int id;
  final String texto;

  OpcioneResponse({required this.id, required this.texto});

  factory OpcioneResponse.fromJson(Map<String, dynamic> json) =>
      OpcioneResponse(id: json["id"], texto: json["texto"]);

  Map<String, dynamic> toJson() => {"id": id, "texto": texto};
}
