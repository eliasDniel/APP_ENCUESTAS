
import 'dart:io';
import 'package:app_encuentas_prueba_tecnica/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../domain/entities/push_message.dart';
part 'notifications_event.dart';
part 'notifications_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  ("Handling a background message: ${message.messageId}");
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationsChangeStatus>(_notificationsStatusChange);
    on<NotificationsSaveNotifications>(_saveNotification);
    on<NotificationsSaveToken>(_saveToken);
    _initialStatusCheck();
    _foreGroundMessage();
  }

  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationsChangeStatus(settings.authorizationStatus));
  }

  Future<String> _getTokenFCM() async {
    if (state.status != AuthorizationStatus.authorized) return '';
    final token = await messaging.getToken();
    if (token == null) return '';
    return token;
  }

  void handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;
    final notification = PushMessage(
      messageId:
          message.messageId?.replaceAll(';', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid
          ? message.notification?.android?.imageUrl
          : message.notification?.apple?.imageUrl,
    ); // PushM
    add(NotificationsSaveNotifications(notification));
  }

  void _saveNotification(
      NotificationsSaveNotifications event, Emitter<NotificationsState> emit) {
    emit(state
        .copyWith(notifications: [event.pushMessage, ...state.notifications]));
  }

  void _saveToken(
      NotificationsSaveToken event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(token: event.token));
  }

  void _foreGroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  void _notificationsStatusChange(
      NotificationsChangeStatus event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(status: event.status));
    // _getTokenFCM();
  }

  void requestPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    add(NotificationsChangeStatus(settings.authorizationStatus));
  }

  PushMessage? getMessage(String pushMessageId) {
    final exits = state.notifications.any(
      (element) => element.messageId == pushMessageId,
    );
    if (!exits) return null;
    return state.notifications.firstWhere(
      (element) => element.messageId == pushMessageId,
    );
  }
}
