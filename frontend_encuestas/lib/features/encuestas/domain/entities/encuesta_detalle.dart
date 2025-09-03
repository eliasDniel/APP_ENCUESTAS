
class DetalleEncuesta {
  final int id;
  final String titulo;
  final String descripcion;
  final List<Pregunta> preguntas;

  DetalleEncuesta({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.preguntas,
  });
}

class Pregunta {
  final String texto;
  final String tipo;
  final List<Opcion> opciones;

  Pregunta({
    required this.texto,
    required this.tipo,
    required this.opciones,
  });
}

class Opcion {
  final String texto;

  Opcion({required this.texto});
}