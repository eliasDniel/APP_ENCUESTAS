import 'package:dio/dio.dart';
import '../../../../config/config.dart';
import '../../domain/domain.dart';
import '../infrastructure.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final dio = Dio(BaseOptions(baseUrl: Enviroment.apiUrl));

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final loginResponse = LoginResponse.fromJson(response.data);
      return UserMapper.userJsonToEntity(loginResponse);
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectionTimeout) {
        throw CustomError('Revisar conexión');
      }
      if (e.response?.statusCode == 401) {
        throw CustomError(
          e.response?.data['message'] ?? 'Credenciales invalidas',
        );
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String email, String password, String fullname) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<User> checkStatus(String token) {
    // TODO: implement checkStatus
    throw UnimplementedError();
  }
}
