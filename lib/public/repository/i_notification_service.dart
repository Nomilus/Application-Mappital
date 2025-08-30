import 'package:application_mappital/core/model/notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class INotificationService {
  Future<void> initNotifications();
  Future<void> initPushNotifications();
  Future<void> handleMessageOnOpenedApp(RemoteMessage? message);
  Future<void> handleMessageOnInApp(RemoteMessage? message);
  Future<NotificationModel?> pushMessage({
    required String title,
    required String message,
    required double latitude,
    required double longitude,
    required NotificationStatus type,
  });
  Future<void> cancelMessage({required String id});
  void removeAllMessage();
}
