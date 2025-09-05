
import '../domain.dart';


/// ! LOGICA DE NEGOCIO
abstract class EncuestasDatasource {

  // ! CONSULTAR TODAS LAS ENCUESTAS
  Future<List<Encuesta>> getNowEncuestas({int page = 1});
  // ! CONSULTAR ENCUESTA POR ID
  Future<DetalleEncuesta> getEncuestaById(int id);
  // ! ENVIAR RESPUESTA DE ENCUESTA
  Future<Encuesta> submitEncuesta(Map<String, dynamic> body);
  // ! RESPONDER ENCUESTA
  Future<Encuesta> responderEncuesta(Map<String, dynamic> body);

  // ! CONSULTAR RESULTADOS DE ENCUESTA POR ID
  Future<EncuestasResultDetail> getResultadosEncuestaById(int id);


  // ! ELIMINAR ENCUESTA
  Future<bool> deleteEncuesta(int id);
  
}
