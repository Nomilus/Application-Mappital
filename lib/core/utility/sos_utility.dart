import 'dart:ui';

import 'package:application_mappital/core/model/notification_model.dart';
import 'package:application_mappital/private/service/location_service.dart';
import 'package:application_mappital/public/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

class SosUtility {
  static OverlayEntry? _overlayEntry;

  static void showSos() {
    if (_overlayEntry != null) {
      return;
    }

    if (Get.overlayContext == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOverlaySos();
      });
    } else {
      _showOverlaySos();
    }
  }

  static void hideOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  static void _showOverlaySos() {
    if (Get.overlayContext == null || _overlayEntry != null) {
      return;
    }

    RxString idNotify = "".obs;

    final NotificationService notificationService =
        Get.find<NotificationService>();
    final LocationService locationService = Get.find<LocationService>();

    final overlayEntry = OverlayEntry(
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
          child: ColoredBox(
            color: Colors.black54,
            child: SafeArea(
              child: Obx(() {
                return Stack(
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Get.theme.colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Get.theme.colorScheme.onInverseSurface,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    Get.theme.colorScheme.surfaceContainerHigh,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person_pin,
                                size: 128,
                                color: Get.theme.iconTheme.color,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                Text(
                                  'ระบบขอความช่วยเหลื่อ',
                                  textAlign: TextAlign.center,
                                  style: Get.theme.textTheme.headlineMedium,
                                ),
                                Text(
                                  'ระบบนี้จะแสดงตำแหน่งของคุณ เพื่อให้ผู้ทุกคนเห็นและสามารถเข้าช่วยเหลื่อคุณได้',
                                  textAlign: TextAlign.center,
                                  style: Get.theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              spacing: 8,
                              children: [
                                Visibility(
                                  visible: idNotify.isEmpty,
                                  child: Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        Vibration.hasAmplitudeControl();
                                        final hasVibrator =
                                            await Vibration.hasVibrator();
                                        final currentLocation =
                                            await locationService
                                                .getCurrentLocation();
                                        if (hasVibrator) {
                                          await Vibration.vibrate(
                                            duration: 500,
                                          );
                                        }
                                        final data = await notificationService
                                            .pushMessage(
                                              title: "SOS",
                                              message:
                                                  "มีผู้ต้องการความช่วยเหลือ",
                                              latitude:
                                                  currentLocation.latitude,
                                              longitude:
                                                  currentLocation.longitude,
                                              type: NotificationStatus.danger,
                                            );
                                        idNotify(data?.id ?? "");
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                          Get
                                              .theme
                                              .colorScheme
                                              .surfaceContainerHigh,
                                        ),
                                      ),
                                      child: Text(
                                        'SOS',
                                        style:
                                            Get.theme.textTheme.headlineMedium,
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: idNotify.isNotEmpty,
                                  child: Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await notificationService.cancelMessage(
                                          id: idNotify.value,
                                        );
                                        hideOverlay();
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                          Get
                                              .theme
                                              .colorScheme
                                              .surfaceContainerHigh,
                                        ),
                                      ),
                                      child: Text(
                                        'Cancel',
                                        style:
                                            Get.theme.textTheme.headlineMedium,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: idNotify.isEmpty,
                      child: Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(
                                  (0.2 * 255).toInt(),
                                ),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () => hideOverlay(),
                            icon: const Icon(Icons.close),
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  Get.theme.colorScheme.surfaceContainerLow,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );

    _overlayEntry = overlayEntry;

    Overlay.of(Get.overlayContext!).insert(overlayEntry);
  }
}
