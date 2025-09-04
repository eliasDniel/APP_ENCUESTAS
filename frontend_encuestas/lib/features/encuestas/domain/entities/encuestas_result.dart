class EncuestasResultDetail {
  final int encuestaId;
  final String titulo;
  final List<PreguntasResueltas> resultados;

  EncuestasResultDetail({
    required this.encuestaId,
    required this.titulo,
    required this.resultados,
  });
}

class PreguntasResueltas {
  final int preguntaId;
  final String texto;
  final List<OpcioneEncuesta> opciones;
  final int countRespuestasAbiertas;
  final List<RespuestasAbierta> respuestasAbiertas;

  PreguntasResueltas({
    required this.preguntaId,
    required this.texto,
    required this.opciones,
    required this.countRespuestasAbiertas,
    required this.respuestasAbiertas,
  });
}

class OpcioneEncuesta {
  final int opcionId;
  final String texto;
  final int countRespuestasOption;
  final List<UsuarioEncuesta> usuarios;

  OpcioneEncuesta({
    required this.opcionId,
    required this.texto,
    required this.countRespuestasOption,
    required this.usuarios,
  });
}

class RespuestasAbierta {
  final int usuarioId;
  final String usuario;
  final String respuestaTexto;

  RespuestasAbierta({
    required this.usuarioId,
    required this.usuario,
    required this.respuestaTexto,
  });
}

class UsuarioEncuesta {
  final int usuarioId;
  final String usuario;

  UsuarioEncuesta({required this.usuarioId, required this.usuario});
}
