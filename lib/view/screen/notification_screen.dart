import 'package:application_mappital/core/model/notification_model.dart';
import 'package:application_mappital/view/event/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final RxBool showBorder = false.obs;

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => AppBar(
            title: Text('Notification', style: theme.textTheme.headlineMedium),
            surfaceTintColor: Colors.transparent,
            backgroundColor: theme.colorScheme.surfaceContainerLowest,
            shape: showBorder.value
                ? Border(
                    bottom: BorderSide(color: Colors.grey.shade400, width: 1.0),
                  )
                : null,
            elevation: 0,
            actions: [
              Obx(
                () => controller.isLoading.value
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : TextButton(
                        onPressed: controller.dismissAllNotification,
                        child: Text(
                          'ลบทั้งหมด',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshNotifications,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() {
              if (controller.notificationList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off_outlined,
                        size: 64,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "ไม่มีการแจ้งเตือน",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification) {
                    showBorder(scrollNotification.metrics.pixels > 15);
                  }
                  return false;
                },
                child: ListView.separated(
                  itemCount: controller.notificationList.length,
                  itemBuilder: (context, index) {
                    final notification = controller.notificationList[index];
                    return Dismissible(
                      key: ValueKey<String>(notification.id),
                      onDismissed: (_) =>
                          controller.dismissNotification(notification),
                      direction: DismissDirection.startToEnd,
                      child: _buildNotificationItem(
                        notification: notification,
                        theme: theme,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required NotificationModel notification,
    required ThemeData theme,
  }) {
    final bool isDanger = notification.type == NotificationStatus.danger;

    debugPrint("Type: ${notification.type}");

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.onInverseSurface),
      ),
      child: ListTile(
        leading: Card(
          color: isDanger
              ? theme.colorScheme.errorContainer
              : theme.colorScheme.primaryContainer,
          shape: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              isDanger ? Icons.warning : Icons.notifications,
              color: isDanger
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
            ),
          ),
        ),
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              notification.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              ' • ${controller.formatDateTime(notification.createdAt)}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
        subtitle: Text(
          notification.message,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          if (notification.type == NotificationStatus.danger) {
            Get.toNamed(
              '/home',
              arguments: LatLng(notification.latitude, notification.longitude),
            );
          }
        },
        contentPadding: const EdgeInsets.all(8),
      ),
    );
  }
}
