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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Get.back(),
        ),
        title: const Text("โปรไฟล์"),
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
                  context: context,
                  title: "เพิ่มโรงพยาบาล",
                  content: "คุณสามารถเพิ่มข้อมูลโรงพยาบาลใหม่ลงในระบบได้",
                  prefix: IconButton(
                    onPressed: () => Get.toNamed('/form'),
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ),
                _buildItemListButton(
                  context: context,
                  title: "โหมดมืด",
                  content: "เปลี่ยนโหมดการแสดงผลเป็นสีเข้ม",
                  prefix: Obx(
                    () => Switch(
                      value: controller.isDarkMode.value,
                      onChanged: (value) => controller.toggleTheme(value),
                    ),
                  ),
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
    required BuildContext context,
    required String title,
    required String content,
    Widget? prefix,
  }) {
    ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: theme.colorScheme.surfaceContainerLow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
          Visibility(
            visible: prefix != null,
            child: Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: prefix,
              ),
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
