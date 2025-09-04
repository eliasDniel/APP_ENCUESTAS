



import '../domain.dart';

abstract class EncuestasRepository {
  Future<List<Encuesta>> getNowEncuestas({int page = 1});
  Future<DetalleEncuesta> getEncuestaById(int id);
  Future<Encuesta> submitEncuesta(Map<String, dynamic> body);
  Future<Encuesta> responderEncuesta(Map<String, dynamic> body);
}
