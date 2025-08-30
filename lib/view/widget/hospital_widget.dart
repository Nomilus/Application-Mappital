import 'package:application_mappital/core/utility/overlay_utility.dart';
import 'package:flutter/material.dart';
import 'package:application_mappital/core/model/hospital_model.dart';
import 'package:get/get.dart';

class HospitalWidget extends StatelessWidget {
  HospitalWidget({super.key, required this.hospital});

  final HospitalModel hospital;
  final RxBool showBorder = false.obs;

  String _getHospitalTypeText(HospitalType type) {
    switch (type) {
      case HospitalType.government:
        return "โรงพยาบาลรัฐ";
      case HospitalType.private:
        return "โรงพยาบาลเอกชน";
      case HospitalType.university:
        return "โรงพยาบาลมหาวิทยาลัย";
      case HospitalType.community:
        return "โรงพยาบาลชุมชน";
      case HospitalType.clinic:
        return "คลินิก";
      case HospitalType.specialized:
        return "โรงพยาบาลเฉพาะทาง";
      case HospitalType.militaryPolice:
        return "โรงพยาบาลทหาร/ตำรวจ";
      case HospitalType.veterinary:
        return "โรงพยาบาลสัตว์";
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    ThemeData theme = Theme.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.2,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLowest,
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
              onPressed: () => Get.toNamed('/form', arguments: hospital),
              icon: const Icon(Icons.edit),
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surfaceContainerLow,
              ),
            ),
          ),
          Expanded(
            flex: 0,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close),
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
    final Rxn<PageController> pageController = Rxn<PageController>(
      PageController(initialPage: 0),
    );
    final currentPageIndex = 0.obs;
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: pageController.value,
              itemCount: hospital.images.length,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                currentPageIndex.value = index;
              },
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GestureDetector(
                      onTap: () =>
                          OverlayUtility.showImage(hospital.images[index].path),
                      child: Image.network(
                        hospital.images[index].path,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: theme.colorScheme.surfaceContainerLow,
                            child: Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: theme.colorScheme.surfaceContainerLow,
                            child: Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: theme.colorScheme.surfaceContainer,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Obx(() {
            return Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha((0.5 * 255).toInt()),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      hospital.images.length,
                      (index) => GestureDetector(
                        onTap: () {
                          pageController.value?.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: currentPageIndex.value == index ? 20 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: currentPageIndex.value == index
                                ? Colors.white
                                : Colors.white.withAlpha((0.5 * 255).toInt()),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
          if (hospital.images.length > 1)
            Positioned(
              top: 8,
              right: 8,
              child: Obx(() {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha((0.5 * 255).toInt()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${currentPageIndex.value + 1}/${hospital.images.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }),
            ),
        ],
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
            SelectableText(
              hospital.description,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.colorScheme.onInverseSurface),
              ),
              child: SelectableText(
                'ประเภท: ${_getHospitalTypeText(hospital.type)}',
                style: theme.textTheme.labelMedium,
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
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.colorScheme.onInverseSurface),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'เปิด: ${hospital.opening} น.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'ปิด: ${hospital.closing} น.',
                    style: theme.textTheme.bodyMedium?.copyWith(
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
            SelectableText(hospital.address, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.colorScheme.onInverseSurface),
              ),
              child: SelectableText(
                'ตำแหน่ง: ${hospital.latitude.toStringAsFixed(6)}, ${hospital.longitude.toStringAsFixed(6)}',
                style: theme.textTheme.bodySmall,
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
                Icon(Icons.phone, color: theme.iconTheme.color, size: 20),
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
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.colorScheme.onInverseSurface),
              ),
              child: SelectableText(
                hospital.phoneNumber,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
