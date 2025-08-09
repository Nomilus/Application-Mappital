import 'package:application_mappital/utility/overlay_utility.dart';
import 'package:flutter/material.dart';
import 'package:application_mappital/public/model/hospital_model.dart';
import 'package:application_mappital/view/event/hospital_controller.dart';
import 'package:get/get.dart';

class HospitalScreen extends StatelessWidget {
  HospitalScreen({super.key, required this.hospital});

  final HospitalModel hospital;
  final HospitalController controller = Get.put(HospitalController());

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    ThemeData theme = Theme.of(context);
    RxBool showBorder = false.obs;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.2,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Divider(
                  indent: mediaQuery.size.width / 2.7,
                  endIndent: mediaQuery.size.width / 2.7,
                  color: theme.colorScheme.outline,
                  radius: BorderRadius.circular(100),
                  thickness: 6,
                  height: 16,
                ),
                Obx(() {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      border: showBorder.value
                          ? Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            )
                          : null,
                    ),
                    child: _buildHeaderContent(
                      hospital: hospital,
                      theme: theme,
                    ),
                  );
                }),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollUpdateNotification) {
                        showBorder(scrollNotification.metrics.pixels > 15);
                      }
                      return false;
                    },
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        NotificationListener<ScrollNotification>(
                          onNotification: (scrollNotification) {
                            return true;
                          },
                          child: _buildImageGallery(
                            hospital: hospital,
                            theme: theme,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoSection(hospital: hospital, theme: theme),
                        const SizedBox(height: 16),
                        _buildOperatingHours(hospital: hospital, theme: theme),
                        const SizedBox(height: 16),
                        _buildLocationSection(hospital: hospital, theme: theme),
                        const SizedBox(height: 16),
                        _buildContactSection(hospital: hospital, theme: theme),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderContent({
    required HospitalModel hospital,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(hospital.title, style: theme.textTheme.titleMedium),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 0,
            child: IconButton(
              onPressed: () => Get.toNamed('/form'),
              icon: const Icon(Icons.edit_rounded),
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surfaceContainerLow,
              ),
            ),
          ),
          Expanded(
            flex: 0,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close_rounded),
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surfaceContainerLow,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery({
    required HospitalModel hospital,
    required ThemeData theme,
  }) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: hospital.images.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.1 * 255).toInt()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GestureDetector(
                onTap: () => OverlayUtility.showImage(hospital.images[index]),
                child: Image.network(
                  hospital.images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: theme.colorScheme.surfaceContainerLow,
                      child: Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: theme.colorScheme.surfaceContainerLow,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection({
    required HospitalModel hospital,
    required ThemeData theme,
  }) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_hospital,
                  color: theme.iconTheme.color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'ข้อมูลโรงพยาบาล',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              hospital.description,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'ประเภท: ${controller.getHospitalTypeText(hospital.type)}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperatingHours({
    required HospitalModel hospital,
    required ThemeData theme,
  }) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time, color: theme.iconTheme.color, size: 20),
                const SizedBox(width: 8),
                Text(
                  'เวลาทำการ',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'เปิด: ${hospital.opening} น.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'ปิด: ${hospital.closing} น.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection({
    required HospitalModel hospital,
    required ThemeData theme,
  }) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.contact_phone,
                  color: theme.iconTheme.color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'ติดต่อ',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.phone,
                    color: theme.colorScheme.onPrimary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  SelectableText(
                    hospital.phoneNumber,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection({
    required HospitalModel hospital,
    required ThemeData theme,
  }) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: theme.iconTheme.color, size: 20),
                const SizedBox(width: 8),
                Text(
                  'ที่อยู่',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(hospital.address, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              'พิกัด: ${hospital.latitude.toStringAsFixed(6)}, ${hospital.longitude.toStringAsFixed(6)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
