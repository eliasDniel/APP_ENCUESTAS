// ! 1. DEFINIR EL ESTADO DEL FORMULARIO
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import '../../../shared/infrastructure/infrastructure.dart';
import 'providers.dart';



class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) {
    return LoginFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'LoginFormState(isPosting: $isPosting, isFormPosted: $isFormPosted, isValid: $isValid, email: $email, password: $password)';
  }
}

// ! 2. CREAR EL ESTADO DEL FORMULARIO
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final String tokenFCM;
  final Function(String email, String password, String tokenFCM) loginFormCallback;

  LoginFormNotifier({required this.loginFormCallback, required this.tokenFCM})
    : super(LoginFormState());

  onEmailChanged(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password]),
    );
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email]),
    );
  }

  onSubmit() async {
    _touchEveryField();
    if (!state.isValid) return;
    state = state.copyWith(isPosting: true);
    await loginFormCallback(state.email.value, state.password.value, tokenFCM);
    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([email, password]),
    );
  }
}


// ! 3. IMPLEMENTAR EL ESTADO PARA CONSUMIR EN EL FRONTEND
final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
      final loginFormCallback = ref.watch(authProvider.notifier).loginUser;
      final tokenFCM = ref.watch(fcmTokenProvider).maybeWhen(
    data: (token) => token ?? '',
    orElse: () => '',
  );

      return LoginFormNotifier(loginFormCallback: loginFormCallback, tokenFCM: tokenFCM);
    });