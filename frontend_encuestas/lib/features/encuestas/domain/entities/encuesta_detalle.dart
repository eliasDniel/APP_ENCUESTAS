
class DetalleEncuesta {
  final int id;
  final String titulo;
  final String descripcion;
  final List<Pregunta> preguntas;
  final String estado;

  DetalleEncuesta({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.preguntas,
    required this.estado,
  });
}

class Pregunta {
  final int id;
  final String texto;
  final String tipo;
  final List<Opcion> opciones;

  Pregunta({
    required this.id,
    required this.texto,
    required this.tipo,
    required this.opciones,
  });
}

class Opcion {
  final int id;
  final String texto;

  Opcion({required this.id, required this.texto});
}