




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
  Future<User> login(String email, String password) {
    return dataSources.login(email, password);
  }

  @override
  Future<User> register(String email, String password, String fullname) {
    return dataSources.register(email, password, fullname);
  }

  @override
  Future<User> checkStatus(String token) {
    return dataSources.checkStatus(token);
  }
}