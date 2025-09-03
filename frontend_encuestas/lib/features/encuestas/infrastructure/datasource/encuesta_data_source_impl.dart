import 'package:app_encuentas_prueba_tecnica/features/encuestas/infrastructure/models/encuestas_response.dart';
import 'package:dio/dio.dart';
import '../../../../config/config.dart';
import '../../../auth/infrastructure/infrastructure.dart';
import '../../domain/domain.dart';
import '../mappers/encuestas_mapper.dart';

class EncuestasDataSourceImpl implements EncuestasDatasource {
  late final Dio dio;
  final String accessToken;

  EncuestasDataSourceImpl({required this.accessToken})
    : dio = Dio(
        BaseOptions(
          baseUrl: Enviroment.apiUrl,
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
  @override
  Future<List<Encuesta>> getNowEncuestas({int page = 1}) async {
    try {
      final response = await dio.get('/encuestas/encuestas/', queryParameters: {'page': page});
      final encuestasResponse = EncuestasResponse.fromJson(response.data);
      final encuestas = encuestasResponse.results
          .map((e) => EncuestasMapper.fromJsonToEntity(e))
          .toList();
      return encuestas;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['message'] ?? 'Token inválido');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<DetalleEncuesta> getEncuestaById(int id) {
    throw UnimplementedError();
  }
}
