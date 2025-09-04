
import '../../domain/domain.dart';
import '../models/encuesta_detalle_response.dart';
import '../models/encuestas_response.dart';

class EncuestasMapper {
  static Encuesta fromJsonToEntity(EncuestaResult json) => Encuesta(
    id: json.id,
    titulo: json.titulo,
    descripcion: json.descripcion,
    fechaCreacion: json.fechaCreacion,
    cantidadPreguntas: json.cantidadPreguntas,
    creadaPor: json.creadaPor,
    estado: json.estado,

  );


  static DetalleEncuesta fromJsonToEntityDetails(EncuestaDetalleResponse json) => DetalleEncuesta(
    id: json.id,
    titulo: json.titulo,
    descripcion: json.descripcion,
    preguntas: json.preguntas.map((e) => fromJsonToEntityPregunta(e)).toList(),
    estado: json.estado,
  );


  static Pregunta fromJsonToEntityPregunta(PreguntaResponse json) => Pregunta(
    id: json.id,
    texto: json.texto,
    tipo: json.tipo,
    opciones: json.opciones.map((e) => fromJsonToEntityOpcion(e)).toList(),
  );

  static Opcion fromJsonToEntityOpcion(OpcioneResponse json) => Opcion(
    id: json.id,
    texto: json.texto,
  );
}
