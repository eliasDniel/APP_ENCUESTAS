import 'package:app_encuentas_prueba_tecnica/features/auth/presentation/screens/check_auth_status_screen.dart';
import 'package:app_encuentas_prueba_tecnica/features/encuestas/presentation/screens/encuesta_screen.dart';
import 'package:app_encuentas_prueba_tecnica/features/encuestas/presentation/screens/resultados_encuesta_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/providers.dart';
import '../../features/auth/presentation/screens/screens.dart';
import '../../features/encuestas/presentation/screens/create_encuesta.dart';
import '../../features/encuestas/presentation/screens/encuestas.dart';
import 'app_router_notifier.dart';

final appRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.watch(goRouterNotifierProvider);
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      ///* Splah Screen
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Encuestas Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const EncuestaScreen(),

        routes: [
          GoRoute(
            path: 'encuesta/:id',
            name: DetalleEncuestaScreen.routeName,
            builder: (context, state) {
              final encuestaId = state.params['id']!;
              return DetalleEncuestaScreen(encuestaId: encuestaId);
            },
          ),
          GoRoute(
            path: 'create-encuesta',
            builder: (context, state) => const CreateEncuestaScreen(),
            name: CreateEncuestaScreen.routeName,
          ),
          GoRoute(
            path: 'resultados-encuesta/:id',
            builder: (context, state){
              final encuestaId = state.params['id'] ?? '0';
              return ResultadosEncuestaScreen(encuestaId: encuestaId);
            },
            name: ResultadosEncuestaScreen.routeName,
          ),
        ],
      ),
    ],

    redirect: (context, state) {
      final isGoingTo = state.subloc;
      final authStatus = goRouterNotifier.authStatus;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      }

      if (authStatus == AuthStatus.unauthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') return null;

        return '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash') {
          return '/';
        }
      }

      return null;
    },
  );
});
