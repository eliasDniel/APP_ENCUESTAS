class ResultadosEncuestasResponse {
    final int encuestaId;
    final String titulo;
    final List<PreguntasResueltasResult> resultados;

    ResultadosEncuestasResponse({
        required this.encuestaId,
        required this.titulo,
        required this.resultados,
    });

    factory ResultadosEncuestasResponse.fromJson(Map<String, dynamic> json) => ResultadosEncuestasResponse(
        encuestaId: json["encuesta_id"],
        titulo: json["titulo"],
        resultados: List<PreguntasResueltasResult>.from(json["resultados"].map((x) => PreguntasResueltasResult.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "encuesta_id": encuestaId,
        "titulo": titulo,
        "resultados": List<dynamic>.from(resultados.map((x) => x.toJson())),
    };
}

class PreguntasResueltasResult {
    final int preguntaId;
    final String texto;
    final List<OpcioneResultEncuesta> opciones;
    final int countRespuestasAbiertas;
    final List<RespuestasAbiertaResult> respuestasAbiertas;

    PreguntasResueltasResult({
        required this.preguntaId,
        required this.texto,
        required this.opciones,
        required this.countRespuestasAbiertas,
        required this.respuestasAbiertas,
    });

    factory PreguntasResueltasResult.fromJson(Map<String, dynamic> json) => PreguntasResueltasResult(
        preguntaId: json["pregunta_id"],
        texto: json["texto"],
        opciones: List<OpcioneResultEncuesta>.from(json["opciones"].map((x) => OpcioneResultEncuesta.fromJson(x))),
        countRespuestasAbiertas: json["count_respuestas_abiertas"],
        respuestasAbiertas: List<RespuestasAbiertaResult>.from(json["respuestas_abiertas"].map((x) => RespuestasAbiertaResult.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "pregunta_id": preguntaId,
        "texto": texto,
        "opciones": List<dynamic>.from(opciones.map((x) => x.toJson())),
        "count_respuestas_abiertas": countRespuestasAbiertas,
        "respuestas_abiertas": List<dynamic>.from(respuestasAbiertas.map((x) => x.toJson())),
    };
}

class OpcioneResultEncuesta {
    final int opcionId;
    final String texto;
    final int countRespuestasOption;
    final List<UsuarioResultEncuesta> usuarios;

    OpcioneResultEncuesta({
        required this.opcionId,
        required this.texto,
        required this.countRespuestasOption,
        required this.usuarios,
    });

    factory OpcioneResultEncuesta.fromJson(Map<String, dynamic> json) => OpcioneResultEncuesta(
        opcionId: json["opcion_id"],
        texto: json["texto"],
        countRespuestasOption: json["count_respuestas_option"],
        usuarios: List<UsuarioResultEncuesta>.from(json["usuarios"].map((x) => UsuarioResultEncuesta.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "opcion_id": opcionId,
        "texto": texto,
        "count_respuestas_option": countRespuestasOption,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
    };
}

class UsuarioResultEncuesta {
    final int usuarioId;
    final String usuario;

    UsuarioResultEncuesta({
        required this.usuarioId,
        required this.usuario,
    });

    factory UsuarioResultEncuesta.fromJson(Map<String, dynamic> json) => UsuarioResultEncuesta(
        usuarioId: json["usuario_id"],
        usuario: json["usuario"],
    );

    Map<String, dynamic> toJson() => {
        "usuario_id": usuarioId,
        "usuario": usuario,
    };
}

class RespuestasAbiertaResult {
    final int usuarioId;
    final String usuario;
    final String respuestaTexto;

    RespuestasAbiertaResult({
        required this.usuarioId,
        required this.usuario,
        required this.respuestaTexto,
    });

    factory RespuestasAbiertaResult.fromJson(Map<String, dynamic> json) => RespuestasAbiertaResult(
        usuarioId: json["usuario_id"],
        usuario: json["usuario"],
        respuestaTexto: json["respuesta_texto"],
    );

    Map<String, dynamic> toJson() => {
        "usuario_id": usuarioId,
        "usuario": usuario,
        "respuesta_texto": respuestaTexto,
    };
}
