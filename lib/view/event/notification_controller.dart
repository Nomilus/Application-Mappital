import 'package:application_mappital/core/model/notification_model.dart';
import 'package:application_mappital/public/service/notification_service.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final NotificationService _notificationService =
      Get.find<NotificationService>();

  final RxList<NotificationModel> notificationList = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (_notificationService.currentNotification.isNotEmpty) {
      notificationList.assignAll(_notificationService.currentNotification);
    }
  }

  @override
  void onReady() {
    super.onReady();
    ever(_notificationService.currentNotification, (value) {
      if (value.isNotEmpty) {
        notificationList.assignAll(value);
      } else {
        notificationList.clear();
      }
    });
  }

  Future<void> refreshNotifications() async {
    isLoading(true);
    try {
      if (_notificationService.currentNotification.isNotEmpty) {
        _notificationService.currentNotification.clear();
        notificationList.assignAll(_notificationService.currentNotification);
      }
    } finally {
      isLoading(false);
    }
  }

  void dismissNotification(NotificationModel notification) {
    notificationList.remove(notification);
    if (_notificationService.currentNotification.isNotEmpty) {
      _notificationService.currentNotification.remove(notification);
    }
  }

  void dismissAllNotification() {
    notificationList.clear();
    if (_notificationService.currentNotification.isNotEmpty) {
      _notificationService.currentNotification.clear();
    }
  }

  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} วันที่แล้ว';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ชั่วโมงที่แล้ว';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} นาทีที่แล้ว';
    } else {
      return 'เมื่อสักครู่';
    }
  }
}
