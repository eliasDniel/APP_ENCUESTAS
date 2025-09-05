part of 'notifications_bloc.dart';

class NotificationsState extends Equatable {
  final AuthorizationStatus status;
  final List<PushMessage> notifications;
  final String token;
  const NotificationsState(
      {this.notifications = const [],
      this.status = AuthorizationStatus.notDetermined,
      this.token = ''
      });

  NotificationsState copyWith(
          {AuthorizationStatus? status, List<PushMessage>? notifications, String? token}) =>
      NotificationsState(
          notifications: notifications ?? this.notifications,
          status: status ?? this.status,
          token: token ?? this.token
          );

  @override
  List<Object> get props => [status, notifications];
}
