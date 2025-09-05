import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'config/config.dart';
import 'features/encuestas/presentation/blocs/notifications/notifications_bloc.dart';

void main() async {
  await Enviroment.initEnvironment();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationsBloc.initializeFCM();
  runApp(
    ProviderScope(
      child: MultiBlocProvider(
        providers: [BlocProvider(create: (_) => NotificationsBloc())],
        child: const MainApp(),
      ),
    ),
  );
}

final GlobalKey<ScaffoldMessengerState> messengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);
    return MaterialApp.router(
      scaffoldMessengerKey: messengerKey,
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) =>
          HandleNotificationInteraction(appRouter: appRouter, child: child!),
    );
  }
}

class HandleNotificationInteraction extends StatefulWidget {
  final Widget child;
  final GoRouter appRouter;
  const HandleNotificationInteraction({
    super.key,
    required this.child,
    required this.appRouter,
  });

  @override
  State<HandleNotificationInteraction> createState() =>
      _HandleNotificationInteractionState();
}

class _HandleNotificationInteractionState
    extends State<HandleNotificationInteraction> {
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    context.read<NotificationsBloc>().handleRemoteMessage(message);
    widget.appRouter.push('/');
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
