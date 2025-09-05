part of 'notifications_bloc.dart';

abstract class NotificationsEvent {
  const NotificationsEvent();
}

class NotificationsChangeStatus extends NotificationsEvent {
  final AuthorizationStatus status;
  NotificationsChangeStatus(this.status);
}



class NotificationsSaveNotifications extends NotificationsEvent {
  final PushMessage pushMessage;
  NotificationsSaveNotifications(this.pushMessage);
}


class NotificationsSaveToken extends NotificationsEvent {
  final String token;
  NotificationsSaveToken(this.token);
}