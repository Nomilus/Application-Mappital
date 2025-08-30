import 'package:application_mappital/core/api/notification_api.dart';
import 'package:application_mappital/core/model/notification_model.dart';
import 'package:application_mappital/core/utility/overlay_utility.dart';
import 'package:application_mappital/core/utility/snackbar_utility.dart';
import 'package:application_mappital/public/repository/i_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationService extends GetxService implements INotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final RxList<NotificationModel> currentNotification =
      <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;

  final NotificationApi _notificationApi = NotificationApi();

  @override
  void onInit() {
    super.onInit();
    initNotifications();
  }

  @override
  Future<void> initNotifications() async {
    _firebaseMessaging.subscribeToTopic('all');

    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    initPushNotifications();
  }

  @override
  Future<void> initPushNotifications() async {
    _firebaseMessaging.getInitialMessage().then(handleMessageOnOpenedApp);
    FirebaseMessaging.onMessage.listen(handleMessageOnInApp);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessageOnOpenedApp);
  }

  @override
  Future<void> handleMessageOnOpenedApp(RemoteMessage? message) async {
    if (message == null) return;
    currentNotification(await _notificationApi.findAllNotification());
    Get.toNamed('/notification');
  }

  @override
  Future<void> handleMessageOnInApp(RemoteMessage? message) async {
    if (message == null) return;
    final NotificationModel data = NotificationModel.fromModel(message.data);
    currentNotification(await _notificationApi.findAllNotification());

    SnackbarUtility.info(title: data.title, message: data.message);
  }

  @override
  Future<NotificationModel?> pushMessage({
    required String title,
    required String message,
    required double latitude,
    required double longitude,
    required NotificationStatus type,
  }) async {
    OverlayUtility.showLoading();
    try {
      final NotificationModel? data = await _notificationApi.sendNotification(
        title: title,
        message: message,
        latitude: latitude,
        longitude: longitude,
        type: type,
      );
      if (data != null) {
        currentNotification.clear();
        currentNotification(await _notificationApi.findAllNotification());
      }
      return data;
    } finally {
      OverlayUtility.hideOverlay();
    }
  }

  @override
  Future<void> cancelMessage({required String id}) async {
    if (await _notificationApi.undoNotification(id: id)) {
      currentNotification.clear();
      currentNotification(await _notificationApi.findAllNotification());
    }
  }

  @override
  void removeAllMessage() {
    currentNotification.clear();
  }
}
