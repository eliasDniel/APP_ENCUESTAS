




import '../../domain/domain.dart';
import '../infrastructure.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource dataSources;

  AuthRepositoryImpl(
    {
      AuthDatasource? dataSources
    }
  ) : dataSources = dataSources ?? AuthDatasourceImpl();

  @override
  Future<User> login(String email, String password, String tokenFCM) {
    return dataSources.login(email, password, tokenFCM);
  }

  @override
  Future<User> register(String email, String password, String fullname, String tokenFCM) {
    return dataSources.register(email, password, fullname, tokenFCM);
  }

  @override
  Future<User> checkStatus(String token) {
    return dataSources.checkStatus(token);
  }
}