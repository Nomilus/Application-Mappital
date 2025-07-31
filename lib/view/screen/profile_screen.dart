import 'package:flutter/material.dart';
import 'package:application_mappital/view/event/profile_controller.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text("Profile"),
        actions: const [],
        backgroundColor: theme.colorScheme.surfaceContainerLowest,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                foregroundImage: NetworkImage(controller.user.value!.avatar),
                child: Text(controller.user.value?.name.substring(0, 1) ?? "N"),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                Text(
                  textAlign: TextAlign.center,
                  controller.user.value?.name ?? "unknown",
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  textAlign: TextAlign.center,
                  controller.user.value?.email ?? "-",
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildItemListButton(
                  theme: theme,
                  title: "Dark Mode",
                  content: "เปลี่ยนโหมดการแสดงผลเป็นสีเข้ม",
                  value: controller.isDarkMode,
                  callback: (value) => controller.toggleTheme(value),
                ),
                _buildSignOutButton(theme: theme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemListButton({
    required ThemeData theme,
    required String title,
    required String content,
    required RxBool value,
    required Function(bool value) callback,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: theme.colorScheme.surfaceContainerLow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium, softWrap: true),
                Text(content, style: theme.textTheme.bodySmall, softWrap: true),
              ],
            ),
          ),
          Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Obx(() => Switch(value: value.value, onChanged: callback)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutButton({required ThemeData theme}) {
    return ElevatedButton(
      onPressed: () {
        controller.signOut();
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        backgroundColor: theme.colorScheme.errorContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      child: Row(
        children: [
          Text(
            "Sign out",
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Icon(Icons.logout, color: theme.colorScheme.error),
        ],
      ),
    );
  }
}
