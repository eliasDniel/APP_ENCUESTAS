



import '../domain.dart';

abstract class EncuestasRepository {
  Future<List<Encuesta>> getNowEncuestas({int page = 1});
  Future<DetalleEncuesta> getEncuestaById(int id);
}
