// ! 1. DEFINIR EL ESTADO DEL FORMULARIO
import 'package:app_encuentas_prueba_tecnica/features/shared/infrastructure/inputs/fullname.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import '../../../shared/infrastructure/infrastructure.dart';
import 'providers.dart';



class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final FullName fullName;
  final Email email;
  final Password password;
  final Password confirmPassword;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.fullName = const FullName.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const Password.pure(),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    FullName? fullName,
    Email? email,
    Password? password,
    Password? confirmPassword,
  }) {
    return RegisterFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  @override
  String toString() {
    return 'LoginFormState(isPosting: $isPosting, isFormPosted: $isFormPosted, isValid: $isValid, fullName: $fullName, email: $email, password: $password)';
  }
}

// ! 2. CREAR EL ESTADO DEL FORMULARIO
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String email, String password, String fullname) registerFormCallback;

  RegisterFormNotifier({required this.registerFormCallback})
    : super(RegisterFormState());

    onFullNameChanged(String value) {
    final newFullName = FullName.dirty(value);
    state = state.copyWith(
      fullName: newFullName,
      isValid: Formz.validate([newFullName, state.email, state.password]),
    );
  }

  onEmailChanged(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,  
      isValid: Formz.validate([newEmail, state.password, state.fullName]),
    );
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email, state.fullName]),
    );
  }

  onConfirmPasswordChanged(String value) {
    final newConfirmPassword = Password.dirty(value);
    state = state.copyWith(
      confirmPassword: newConfirmPassword,
      isValid: Formz.validate([newConfirmPassword, state.password, state.email, state.fullName]),
    );
  }

  onSubmit() async {
    _touchEveryField();
    if (!state.isValid) return;
    await registerFormCallback(state.email.value, state.password.value, state.fullName.value);
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
final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>((ref) {
      final registerFormCallback = ref.watch(authProvider.notifier).registerUser;
      return RegisterFormNotifier(registerFormCallback: registerFormCallback);
    });