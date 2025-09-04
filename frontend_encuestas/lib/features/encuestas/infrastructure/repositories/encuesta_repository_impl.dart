import 'package:app_encuentas_prueba_tecnica/features/encuestas/domain/entities/encuestas_result.dart';

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

  @override
  Future<Encuesta> responderEncuesta(Map<String, dynamic> body) {
    return datasource.responderEncuesta(body);
  }

  @override
  Future<Encuesta> submitEncuesta(Map<String, dynamic> body) {
    return datasource.submitEncuesta(body);
  }

  @override
  Future<EncuestasResultDetail> getResultadosEncuestaById(int id) {
    return datasource.getResultadosEncuestaById(id);
  }
}
