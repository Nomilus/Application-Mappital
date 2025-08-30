import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class OverlayUtility {
  static OverlayEntry? _overlayEntry;

  static void showLoading() {
    if (_overlayEntry != null) {
      return;
    }

    if (Get.overlayContext == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOverlayLoading();
      });
    } else {
      _showOverlayLoading();
    }
  }

  static void showImage(dynamic image) {
    if (_overlayEntry != null) {
      return;
    }

    if (Get.overlayContext == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOverlayImage(image);
      });
    } else {
      _showOverlayImage(image);
    }
  }

  static void hideOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  static void _showOverlayLoading() {
    if (Get.overlayContext == null || _overlayEntry != null) {
      return;
    }

    final overlayEntry = OverlayEntry(
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
          child: ColoredBox(
            color: Colors.black54,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(16),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );

    _overlayEntry = overlayEntry;

    Overlay.of(Get.overlayContext!).insert(overlayEntry);
  }

  static void _showOverlayImage(dynamic image) {
    if (Get.overlayContext == null || _overlayEntry != null) {
      return;
    }

    final overlayEntry = OverlayEntry(
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
          child: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: PhotoView(
                    initialScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.contained * 2.0,
                    minScale: PhotoViewComputedScale.contained,
                    basePosition: Alignment.center,
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.black54,
                    ),
                    imageProvider: (image is File)
                        ? FileImage(image)
                        : NetworkImage(image),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.2 * 255).toInt()),
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
              ],
            ),
          ),
        );
      },
    );

    _overlayEntry = overlayEntry;

    Overlay.of(Get.overlayContext!).insert(overlayEntry);
  }  
}
