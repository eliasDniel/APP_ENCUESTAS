
import '../../domain/domain.dart';
import '../../domain/entities/encuestas_result.dart';
import '../models/encuesta_detalle_response.dart';
import '../models/encuestas_response.dart';
import '../models/encuestas_result_response.dart';

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


  static EncuestasResultDetail fromJsonToEntityResultados(ResultadosEncuestasResponse json) => EncuestasResultDetail(
    encuestaId: json.encuestaId,
    titulo: json.titulo,
    resultados: json.resultados.map((e) => fromJsonToEntityPreguntaResult(e)).toList(),
  );

  static PreguntasResueltas fromJsonToEntityPreguntaResult(PreguntasResueltasResult json) => PreguntasResueltas(
    preguntaId: json.preguntaId,
    texto: json.texto,
    opciones: json.opciones.map((e) => fromJsonToEntityOpcionResult(e)).toList(),
    countRespuestasAbiertas: json.countRespuestasAbiertas,
    respuestasAbiertas: json.respuestasAbiertas.map((e) => fromJsonToEntityRespuestaAbiertaResult(e)).toList(),
  );

  static OpcioneEncuesta fromJsonToEntityOpcionResult(OpcioneResultEncuesta json) => OpcioneEncuesta(
    opcionId: json.opcionId,
    texto: json.texto,
    countRespuestasOption: json.countRespuestasOption,
    usuarios: json.usuarios.map((e) => fromJsonToEntityUsuarioEncuesta(e)).toList(),
  );
  static UsuarioEncuesta fromJsonToEntityUsuarioEncuesta(UsuarioResultEncuesta json) => UsuarioEncuesta(
    usuarioId: json.usuarioId,
    usuario: json.usuario,
  );
  static RespuestasAbierta fromJsonToEntityRespuestaAbiertaResult(RespuestasAbiertaResult json) => RespuestasAbierta(
    usuarioId: json.usuarioId,
    usuario: json.usuario,
    respuestaTexto: json.respuestaTexto,
  );
}
