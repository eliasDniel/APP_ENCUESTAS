




import '../domain.dart';

abstract class AuthDatasource {
  Future<User> login(String email, String password, String tokenFCM);
  Future<User> register(String email, String password, String fullname, String tokenFCM);
  Future<User> checkStatus( String token );
}