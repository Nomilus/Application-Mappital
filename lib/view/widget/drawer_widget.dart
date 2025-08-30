import 'package:application_mappital/view/event/drawer_controller.dart';
import 'package:flutter/material.dart' hide DrawerController;
import 'package:badges/badges.dart' as badges;
import 'package:application_mappital/core/model/hospital_model.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({super.key, required this.onTap});

  final void Function(LatLng location) onTap;

  final DrawerController controller = Get.find<DrawerController>();
  final RxBool showBorder = false.obs;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 2));
                },
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification) {
                      showBorder(scrollNotification.metrics.pixels > 15);
                    }
                    return false;
                  },
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        surfaceTintColor: Colors.transparent,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerLowest,
                        automaticallyImplyLeading: false,
                        elevation: 0,
                        title: Text(
                          'Mappital',
                          style: theme.textTheme.headlineMedium,
                        ),
                        actions: [
                          IconButton(
                            onPressed: () => Get.toNamed('/notification'),
                            icon: Obx(() {
                              final count = controller.notification;
                              return badges.Badge(
                                showBadge: count > 0,
                                badgeStyle: badges.BadgeStyle(
                                  badgeColor: theme.colorScheme.errorContainer,
                                  padding: const EdgeInsets.all(5),
                                ),
                                badgeContent: Text(
                                  count > 99 ? '99+' : count.toString(),
                                  style: theme.textTheme.bodySmall?.apply(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                                child: const Icon(Icons.notifications),
                              );
                            }),
                          ),
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.arrow_forward),
                          ),
                        ],
                      ),
                      Obx(
                        () => SliverAppBar(
                          pinned: true,
                          surfaceTintColor: Colors.transparent,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerLowest,
                          automaticallyImplyLeading: false,
                          shape: showBorder.value
                              ? Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 1.0,
                                  ),
                                )
                              : null,
                          elevation: 0,
                          flexibleSpace: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                spacing: 6,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SearchBar(
                                      textInputAction: TextInputAction.done,
                                      hintText: 'ค้นหา',
                                      hintStyle: WidgetStatePropertyAll(
                                        theme.textTheme.bodyMedium,
                                      ),
                                      textStyle: WidgetStatePropertyAll(
                                        theme.textTheme.bodyMedium,
                                      ),
                                      elevation: const WidgetStatePropertyAll(
                                        0,
                                      ),
                                      onSubmitted: (value) =>
                                          controller.findHospital(value),
                                      onTapOutside: (event) => FocusManager
                                          .instance
                                          .primaryFocus
                                          ?.unfocus(),
                                      leading: const Icon(Icons.search),
                                      backgroundColor: WidgetStatePropertyAll(
                                        theme.colorScheme.surfaceContainerLow,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: controller.hospitalList.isNotEmpty,
                                    child: IconButton(
                                      onPressed: () => controller.removeResults(),
                                      icon: const Icon(Icons.clear),
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                          theme.colorScheme.surfaceContainerLow,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      Obx(() {
                        if (controller.hospitalList.isNotEmpty) {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                child: _buildItemList(
                                  hospital: controller.hospitalList[index],
                                  theme: theme,
                                ),
                              );
                            }, childCount: controller.hospitalList.length),
                          );
                        } else {
                          return SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: theme.colorScheme.outline,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "ไม่มีข้อมูลโรงพยาบาล",
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLowest,
              ),
              child: TextButton(
                onPressed: () => Get.toNamed("/profile"),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Obx(() {
                  final userProfile = controller.currentUser;
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        foregroundImage: NetworkImage(
                          userProfile?.avatar ?? '',
                        ),
                        child: Text(userProfile?.name.substring(0, 1) ?? "N"),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userProfile?.name ?? "unknown",
                            style: theme.textTheme.titleMedium,
                          ),
                          Text(
                            userProfile?.email ?? "-",
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemList({
    required HospitalModel? hospital,
    required ThemeData theme,
  }) {
    return ListTile(
      title: Text(hospital?.title ?? '', style: theme.textTheme.titleSmall),
      subtitle: Text(
        '${hospital?.type.toString().split('.').last ?? ''} • ${hospital?.address ?? ''}',
        style: theme.textTheme.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        onTap(
          LatLng(
            hospital?.latitude ?? 13.7563,
            hospital?.longitude ?? 100.5018,
          ),
        );
        Get.back();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      tileColor: theme.colorScheme.surfaceContainerLow,
    );
  }
}
