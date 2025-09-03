import '../domain.dart';

/// ! LOGICA DE NEGOCIO
abstract class EncuestasDatasource {
  Future<List<Encuesta>> getNowEncuestas({int page = 1});
  Future<DetalleEncuesta> getEncuestaById(int id);
}
