import 'package:application_mappital/public/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:application_mappital/public/model/hospital_model.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({
    super.key,
    this.userProfileOnPressed,
    this.hospitalList = const <HospitalModel>[],
    required this.reload,
    required this.onTap,
  });

  final void Function()? userProfileOnPressed;
  final List<HospitalModel> hospitalList;
  final Future<void> Function() reload;
  final void Function(LatLng location) onTap;

  final AuthService _authService = Get.find<AuthService>();

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
                child: Text('Mappital', style: theme.textTheme.headlineSmall),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: reload,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(6),
                    children: List.generate(
                      hospitalList.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: _buildItemList(
                          hospital: hospitalList[index],
                          theme: theme,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: userProfileOnPressed,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Obx(() {
                  final userProfile = _authService.currentUser.value;
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        foregroundImage: NetworkImage(
                          userProfile?.avatar ?? "",
                        ),
                        child: Text(userProfile?.name.substring(0, 1) ?? "N"),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userProfile?.name ?? "unknown",
                            style: theme.textTheme.bodyMedium,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemList({
    required HospitalModel hospital,
    required ThemeData theme,
  }) {
    return ListTile(
      title: Text(hospital.title, style: theme.textTheme.titleSmall),
      subtitle: Text(
        '${hospital.type.toString().split('.').last} • ${hospital.address}',
        style: theme.textTheme.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      onTap: () => onTap(LatLng(hospital.latitude, hospital.longitude)),
      tileColor: theme.colorScheme.surfaceContainerLow,
    );
  }
}
