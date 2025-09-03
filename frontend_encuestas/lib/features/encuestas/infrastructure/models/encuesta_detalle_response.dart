class EncuestaDetalleResponse {
  final int id;
  final String titulo;
  final String descripcion;
  final List<Pregunta> preguntas;

  EncuestaDetalleResponse({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.preguntas,
  });

  factory EncuestaDetalleResponse.fromJson(Map<String, dynamic> json) =>
      EncuestaDetalleResponse(
        id: json["id"],
        titulo: json["titulo"],
        descripcion: json["descripcion"],
        preguntas: List<Pregunta>.from(
          json["preguntas"].map((x) => Pregunta.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "titulo": titulo,
    "descripcion": descripcion,
    "preguntas": List<dynamic>.from(preguntas.map((x) => x.toJson())),
  };
}

class Pregunta {
  final String texto;
  final String tipo;
  final List<Opcione> opciones;

  Pregunta({required this.texto, required this.tipo, required this.opciones});

  factory Pregunta.fromJson(Map<String, dynamic> json) => Pregunta(
    texto: json["texto"],
    tipo: json["tipo"],
    opciones: List<Opcione>.from(
      json["opciones"].map((x) => Opcione.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "texto": texto,
    "tipo": tipo,
    "opciones": List<dynamic>.from(opciones.map((x) => x.toJson())),
  };
}

class Opcione {
  final String texto;

  Opcione({required this.texto});

  factory Opcione.fromJson(Map<String, dynamic> json) =>
      Opcione(texto: json["texto"]);

  Map<String, dynamic> toJson() => {"texto": texto};
}
