import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainer,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: PhotoView(
                backgroundDecoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                imageProvider: NetworkImage(url),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
