
import '../../domain/domain.dart';

class EncuestaRepositoryImpl implements EncuestasRepository {
  final EncuestasDatasource datasource;

  EncuestaRepositoryImpl(this.datasource);

  @override
  Future<List<Encuesta>> getNowEncuestas({int page = 1}) {
    return datasource.getNowEncuestas(page: page);
  }

  @override
  Future<DetalleEncuesta> getEncuestaById(int id) {
    return datasource.getEncuestaById(id);
  }
}