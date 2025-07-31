import 'package:flutter/material.dart';
import 'package:application_mappital/public/model/notification_model.dart';

class EndDrawerWidget extends StatelessWidget {
  const EndDrawerWidget({super.key, required this.notifications});

  final List<NotificationModel> notifications;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Notification',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(6),
                  children: const [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
