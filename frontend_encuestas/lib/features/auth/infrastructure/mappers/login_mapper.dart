import '../../domain/domain.dart';
import '../models/login_response.dart';

class UserMapper {
  static User userJsonToEntity(LoginResponse login) => User(
    id: login.id,
    email: login.email,
    fullname: login.fullName,
    roles: login.roles,
    token: login.token,
  );
}
