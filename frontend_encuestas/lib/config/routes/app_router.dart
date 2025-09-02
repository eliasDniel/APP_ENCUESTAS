import 'package:app_encuentas_prueba_tecnica/features/encuestas/presentation/encuestas.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ///* Auth Routes
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    ///* Product Routes
    GoRoute(
      path: '/',
      builder: (context, state) => const EncuestaScreen(),
    ),
  ],

  ///! TODO: Bloquear si no se está autenticado de alguna manera
);
