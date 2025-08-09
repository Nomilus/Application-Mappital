import 'package:flutter/material.dart';
import 'package:application_mappital/public/model/notification_model.dart';

class EndDrawerWidget extends StatelessWidget {
  const EndDrawerWidget({
    super.key,
    this.notifications = const <NotificationModel>[],
    this.reload,
  });

  final List<NotificationModel> notifications;
  final Future<void> Function()? reload;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          title: const Text('การแจ้งเตือน'),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 2));
            },
            child: Visibility(
              visible: notifications.isNotEmpty,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _buildItemList(
                      notifica: notifications[0],
                      theme: theme,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemList({
    required NotificationModel notifica,
    required ThemeData theme,
  }) {
    return ListTile(
      leading: notifica.status == NotificationStatus.normal
          ? Icon(Icons.info_rounded, color: theme.colorScheme.primary)
          : const Icon(Icons.dangerous, color: Colors.red),
      title: Text(notifica.title, style: theme.textTheme.titleSmall),
      subtitle: Text(
        notifica.message,
        style: theme.textTheme.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      onTap: () {},
      tileColor: theme.colorScheme.surfaceContainerLow,
    );
  }
}
