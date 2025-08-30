import 'dart:io';

import 'package:application_mappital/core/model/hospital_model.dart';
import 'package:application_mappital/core/utility/overlay_utility.dart';
import 'package:application_mappital/view/event/form_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FormScreen extends StatelessWidget {
  FormScreen({super.key});

  final FormController controller = Get.put(FormController());
  final RxBool showBorder = false.obs;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
            backgroundColor: theme.colorScheme.surfaceContainerLowest,
            surfaceTintColor: Colors.transparent,
            title: const Text('สร้าง'),
            elevation: 0,
            shape: showBorder.value
                ? Border(
                    bottom: BorderSide(color: Colors.grey.shade400, width: 1.0),
                  )
                : null,
            actions: [
              Obx(
                () => controller.isLoading.value
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : TextButton(
                        onPressed: controller.saveHospital,
                        child: Text(
                          'บันทึก',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            showBorder(scrollNotification.metrics.pixels > 15);
          }
          return false;
        },
        child: SafeArea(
          child: Form(
            key: controller.formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                return ListView(
                  physics: controller.isFocusMap.value
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 16),
                    _buildTextInput(
                      control: controller.listTextController[0],
                      context: context,
                      label: 'ชื่อโรงพยาบาล',
                      hint: 'โรงพยาบาล',
                      isRequired: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'กรุณากรอกชื่อโรงพยาบาล';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextInput(
                      control: controller.listTextController[1],
                      context: context,
                      label: 'คำอธิบาย',
                      hint: 'ข้อมูลเกียวกับโรงพยาบาล',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    _buildTextInput(
                      control: controller.listTextController[2],
                      context: context,
                      label: 'ที่อยู่',
                      hint: 'เลขที่,หมู่,ถนน,ตำบล,อําเภอ,จังหวัด',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    _buildTextInput(
                      control: controller.listTextController[3],
                      context: context,
                      maxLength: 10,
                      label: 'เบอร์โทรศัพท์',
                      hint: '000-000-0000',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildTimeChanged(
                            context: context,
                            label: "เวลาเปิด",
                            control: controller.listTextController[4],
                            isRequired: true,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: _buildTimeChanged(
                            context: context,
                            label: "เวลาปิด",
                            control: controller.listTextController[5],
                            isRequired: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildHospitalTypeSelector(context: context),
                    const SizedBox(height: 16),
                    _buildGoogleMap(
                      context: context,
                      label: "ตำแหน่งโรงพยาบาล",
                      isRequired: true,
                      tip: "แตะบนแผนที่เพื่อเลือกตำแหน่ง",
                    ),
                    const SizedBox(height: 16),
                    NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) => true,
                      child: Obx(() {
                        return _buildInputImage(
                          context: context,
                          label: "แนบรูปภาพ",
                        );
                      }),
                    ),
                    const SizedBox(height: 32),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHospitalTypeSelector({required BuildContext context}) {
    ThemeData theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          children: [
            Text('ประเภทโรงพยาบาล', style: theme.textTheme.titleSmall),
            const SizedBox(width: 4),
            Text('*', style: TextStyle(color: Colors.red.shade700)),
          ],
        ),
        Obx(
          () => DropdownButtonFormField<HospitalType>(
            value: controller.selectedHospitalType.value,
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerLow,
              hintText: 'เลือกประเภทโรงพยาบาล',
              hintStyle: theme.textTheme.bodyMedium,
              prefixIcon: Icon(
                Icons.local_hospital,
                color: theme.iconTheme.color,
              ),
              border: theme.inputDecorationTheme.border,
              focusedBorder: theme.inputDecorationTheme.focusedBorder,
              enabledBorder: theme.inputDecorationTheme.enabledBorder,
              disabledBorder: theme.inputDecorationTheme.disabledBorder,
              errorBorder: theme.inputDecorationTheme.errorBorder,
              focusedErrorBorder: theme.inputDecorationTheme.focusedErrorBorder,
            ),
            items: HospitalType.values.map((HospitalType type) {
              return DropdownMenuItem<HospitalType>(
                value: type,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      controller.getHospitalTypeText(type),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (HospitalType? newValue) {
              if (newValue != null) {
                controller.selectedHospitalType(newValue);
              }
            },
            validator: (value) {
              if (value == null) {
                return 'กรุณาเลือกประเภทโรงพยาบาล';
              }
              return null;
            },
            dropdownColor: theme.colorScheme.surface,
            style: theme.textTheme.bodyMedium,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextInput({
    required BuildContext context,
    required TextEditingController control,
    int maxLines = 1,
    int? maxLength,
    String? label,
    String? hint,
    Icon? icon,
    String? tip,
    bool isRequired = false,
    String? Function(String?)? validator,
  }) {
    ThemeData theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Visibility(
          visible: label != null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              Text(label ?? '', style: theme.textTheme.titleSmall),
              if (isRequired) ...[
                const SizedBox(width: 2),
                Text('*', style: TextStyle(color: Colors.red.shade700)),
              ],
              Visibility(
                visible: tip != null,
                child: Tooltip(
                  message: tip ?? '',
                  child: Icon(
                    Icons.info_outline,
                    size: theme.textTheme.bodyLarge!.fontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
        TextFormField(
          controller: control,
          maxLines: maxLines,
          maxLength: maxLength,
          validator: validator,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerLow,
            prefixIcon: icon,
            suffixIcon: maxLines == 1
                ? ValueListenableBuilder<TextEditingValue>(
                    valueListenable: control,
                    builder: (context, value, child) {
                      if (value.text.isNotEmpty) {
                        return IconButton(
                          onPressed: control.clear,
                          icon: const Icon(Icons.close),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  )
                : null,
            hintText: hint,
            hintStyle: theme.textTheme.bodyMedium!.apply(color: Colors.grey),
            border: theme.inputDecorationTheme.border,
            focusedBorder: theme.inputDecorationTheme.focusedBorder,
            enabledBorder: theme.inputDecorationTheme.enabledBorder,
            disabledBorder: theme.inputDecorationTheme.disabledBorder,
            errorBorder: theme.inputDecorationTheme.errorBorder,
            focusedErrorBorder: theme.inputDecorationTheme.focusedErrorBorder,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleMap({
    required BuildContext context,
    String? label,
    String? tip,
    bool isRequired = false,
  }) {
    ThemeData theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Visibility(
          visible: label != null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              Text(label ?? '', style: theme.textTheme.titleSmall),
              if (isRequired) ...[
                const SizedBox(width: 2),
                Text('*', style: TextStyle(color: Colors.red.shade700)),
              ],
              Visibility(
                visible: tip != null,
                child: Tooltip(
                  message: tip ?? '',
                  child: Icon(
                    Icons.info_outline,
                    size: theme.textTheme.bodyLarge!.fontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
        TapRegion(
          onTapOutside: (event) => controller.isFocusMap(false),
          onTapInside: (event) => controller.isFocusMap(true),
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              border: controller.isFocusMap.value
                  ? Border.all(
                      color: theme.colorScheme.primaryContainer,
                      width: 1,
                    )
                  : Border.all(color: Colors.grey.shade400, width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Obx(() {
                  return GoogleMap(
                    onMapCreated: (value) {
                      if (!controller.mapController.value!.isCompleted) {
                        controller.mapController.value!.complete(value);
                      }
                    },
                    onTap: controller.addMarker,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(13.7563, 100.5018),
                      zoom: 11,
                    ),
                    markers: controller.markers.value ?? {},
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<PanGestureRecognizer>(
                        () => PanGestureRecognizer(),
                      ),
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    rotateGesturesEnabled: false,
                    mapToolbarEnabled: false,
                  );
                }),
              ),
            ),
          ),
        ),
        Obx(() {
          if (controller.selectedLocation.value != null) {
            final location = controller.selectedLocation.value!;
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  border: Border.all(color: theme.colorScheme.onInverseSurface),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: SelectableText(
                        'ตำแหน่ง: ${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildTimeChanged({
    required BuildContext context,
    required TextEditingController control,
    String? label,
    String? tip,
    bool isRequired = false,
  }) {
    ThemeData theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Visibility(
          visible: label != null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 2,
            children: [
              Text(label ?? '', style: theme.textTheme.titleSmall),
              if (isRequired) ...[
                const SizedBox(width: 2),
                Text('*', style: TextStyle(color: Colors.red.shade700)),
              ],
              Visibility(
                visible: tip != null,
                child: Tooltip(
                  message: tip ?? '',
                  child: Icon(
                    Icons.info_outline,
                    size: theme.textTheme.bodyLarge!.fontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () async {
            final selectedTime = await controller.selectTime(context);
            if (selectedTime != null) {
              control.text =
                  '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
            }
          },
          child: TextFormField(
            controller: control,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            enabled: false,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerLow,
              hintText: "00:00",
              hintStyle: theme.textTheme.bodyMedium,
              suffixIcon: Icon(Icons.access_time, color: theme.iconTheme.color),
              border: theme.inputDecorationTheme.border,
              focusedBorder: theme.inputDecorationTheme.focusedBorder,
              enabledBorder: theme.inputDecorationTheme.enabledBorder,
              disabledBorder: theme.inputDecorationTheme.disabledBorder,
              errorBorder: theme.inputDecorationTheme.errorBorder,
              focusedErrorBorder: theme.inputDecorationTheme.focusedErrorBorder,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputImage({
    required BuildContext context,
    String? label,
    String? tip,
  }) {
    ThemeData theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: theme.textTheme.titleSmall),
              if (tip != null) ...[
                const SizedBox(width: 4),
                Tooltip(
                  message: tip,
                  child: Icon(
                    Icons.info_outline,
                    size: theme.textTheme.bodyLarge?.fontSize ?? 16,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
        ],
        AspectRatio(
          aspectRatio: 3 / 1,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: ElevatedButton(
                  onPressed: () => controller.upLoadImage(),
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        color: theme.iconTheme.color,
                        size: 30,
                      ),
                      const SizedBox(height: 4),
                      Text("เพิ่มรูปภาพ", style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
              if (controller.listImage.value != null)
                ...controller.listImage.value!.asMap().entries.map((entry) {
                  int index = entry.key;
                  var image = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GestureDetector(
                          onTap: () => OverlayUtility.showImage(image),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: _buildImageWidget(
                                  image: image,
                                  theme: theme,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 30,
                                    maxHeight: 30,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.errorContainer
                                        .withAlpha((0.8 * 255).toInt()),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () =>
                                        controller.unDoImage(index),
                                    icon: Icon(
                                      Icons.clear,
                                      color: theme.colorScheme.error,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageWidget({required dynamic image, required ThemeData theme}) {
    if (image is String && image.isNotEmpty) {
      return Positioned.fill(
        child: Image.network(
          image,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: theme.colorScheme.surfaceContainerLow,
              child: Icon(
                Icons.image_not_supported,
                color: theme.colorScheme.surfaceContainer,
              ),
            );
          },
        ),
      );
    } else if (image is File) {
      return Positioned.fill(
        child: Image.file(
          image,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: theme.colorScheme.surfaceContainerLow,
              child: Icon(
                Icons.image_not_supported,
                color: theme.colorScheme.surfaceContainer,
              ),
            );
          },
        ),
      );
    } else {
      return Positioned.fill(
        child: Container(
          color: theme.colorScheme.surfaceContainerLow,
          child: Icon(
            Icons.image_not_supported,
            color: theme.colorScheme.surfaceContainer,
          ),
        ),
      );
    }
  }
}
