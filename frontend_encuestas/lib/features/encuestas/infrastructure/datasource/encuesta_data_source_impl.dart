import 'package:app_encuentas_prueba_tecnica/features/encuestas/domain/entities/encuestas_result.dart';
import 'package:app_encuentas_prueba_tecnica/features/encuestas/infrastructure/models/encuestas_response.dart';
import 'package:dio/dio.dart';
import '../../../../config/config.dart';
import '../../../auth/infrastructure/infrastructure.dart';
import '../../domain/domain.dart';
import '../mappers/encuestas_mapper.dart';
import '../models/encuesta_detalle_response.dart';
import '../models/encuestas_result_response.dart';

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
      final response = await dio.get(
        '/encuestas/encuestas/',
        queryParameters: {'page': page},
      );
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
  Future<DetalleEncuesta> getEncuestaById(int id) async {
    try {
      final response = await dio.get('/encuestas/encuestas/$id');
      final encuestaResponse = EncuestaDetalleResponse.fromJson(response.data);
      final encuesta = EncuestasMapper.fromJsonToEntityDetails(
        encuestaResponse,
      );
      return encuesta;
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
  Future<Encuesta> submitEncuesta(Map<String, dynamic> body) async {
    try {
      final response = await dio.post('/encuestas/encuestas/', data: body);
      final encuestaResponse = EncuestaResult.fromJson(response.data);
      return EncuestasMapper.fromJsonToEntity(encuestaResponse);
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['detail'] ?? 'Token inválido');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Encuesta> responderEncuesta(Map<String, dynamic> body) async {
    try {
      final response = await dio.post(
        '/encuestas/encuestas/responder/',
        data: body,
      );
      final encuestaResponse = EncuestaResult.fromJson(response.data);
      final encuesta = EncuestasMapper.fromJsonToEntity(encuestaResponse);
      return encuesta;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['detail'] ?? 'Error al Responder');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<EncuestasResultDetail> getResultadosEncuestaById(int id) async {
    try {
      final response = await dio.get('/encuestas/encuestas/$id/resultados/');
      final resultResponse = ResultadosEncuestasResponse.fromJson(
        response.data,
      );
      final resultados = EncuestasMapper.fromJsonToEntityResultados(
        resultResponse,
      );
      return resultados;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['detail'] ?? 'Token inválido');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<bool> deleteEncuesta(int id) async {
    try {
      await dio.delete('/encuestas/encuestas/$id/eliminar/');
      return true;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['message'] ?? 'Error al Eliminar');
      }

      if (e.response?.statusCode == 404) {
        throw CustomError(e.response?.data['detail'] ?? 'Encuesta no existe');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }
}
