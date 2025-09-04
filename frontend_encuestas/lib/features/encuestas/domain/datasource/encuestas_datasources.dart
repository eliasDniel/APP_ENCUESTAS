import '../domain.dart';

/// ! LOGICA DE NEGOCIO
abstract class EncuestasDatasource {
  Future<List<Encuesta>> getNowEncuestas({int page = 1});
  Future<DetalleEncuesta> getEncuestaById(int id);
  Future<Encuesta> submitEncuesta(Map<String, dynamic> body);
  Future<Encuesta> responderEncuesta(Map<String, dynamic> body);
}
