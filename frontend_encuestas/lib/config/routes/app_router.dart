import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/screens.dart';
import '../../features/encuestas/presentation/encuestas.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    ///* Auth Routes
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    ///* Encuestas Routes
    GoRoute(path: '/', builder: (context, state) => const EncuestaScreen()),
  ],

  ///! TODO: Bloquear si no se está autenticado de alguna manera
);
