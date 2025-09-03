class Encuesta {
  final int id;
  final String titulo;
  final String descripcion;
  final String creadaPor;
  final DateTime fechaCreacion;
  final int cantidadPreguntas;
  final String estado;

  Encuesta({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.creadaPor,
    required this.fechaCreacion,
    required this.cantidadPreguntas,
    required this.estado,
  });
}