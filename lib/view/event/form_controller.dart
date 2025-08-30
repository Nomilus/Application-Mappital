import 'dart:async';
import 'dart:io';
import 'package:application_mappital/core/model/hospital_model.dart';
import 'package:application_mappital/core/utility/snackbar_utility.dart';
import 'package:application_mappital/public/service/auth_service.dart';
import 'package:application_mappital/public/service/hospital_service.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class FormController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final HospitalService _hospitalService = Get.find<HospitalService>();
  final AuthService _authService = Get.find<AuthService>();

  final HospitalModel? hospitalModel = Get.arguments;

  final Rxn<Completer<GoogleMapController>?> mapController =
      Rxn<Completer<GoogleMapController>>(Completer());
  final List<TextEditingController> listTextController = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final Rxn<Set<Marker>?> markers = Rxn<Set<Marker>>({});

  final RxBool isFocusMap = false.obs;
  final RxBool isLoading = false.obs;
  final Rxn<LatLng> selectedLocation = Rxn<LatLng>();
  final Rxn<List<dynamic>> listImage = Rxn<List<dynamic>>([]);
  Rx<HospitalType> selectedHospitalType = HospitalType.government.obs;

  @override
  void onInit() {
    super.onInit();
    listTextController[0].text = hospitalModel?.title ?? '';
    listTextController[1].text = hospitalModel?.description ?? '';
    listTextController[2].text = hospitalModel?.address ?? '';
    listTextController[3].text = hospitalModel?.phoneNumber ?? '';
    listTextController[4].text = hospitalModel?.opening ?? '';
    listTextController[5].text = hospitalModel?.closing ?? '';
    selectedHospitalType = (hospitalModel?.type ?? HospitalType.government).obs;
    if (hospitalModel?.latitude != null && hospitalModel?.longitude != null) {
      final location = LatLng(
        hospitalModel?.latitude ?? 13.7563,
        hospitalModel?.longitude ?? 100.5018,
      );
      addMarker(location);
      moveToLocation(location);
    }
    listImage.value =
        hospitalModel?.images.map((item) => item.path).toList() ?? [];
  }

  void addMarker(LatLng location) {
    markers.value ??= {};
    markers.value!.clear();

    markers.value!.add(
      Marker(markerId: MarkerId(location.toString()), position: location),
    );

    selectedLocation.value = location;
    markers.refresh();
  }

  Future<void> moveToLocation(LatLng location) async {
    final GoogleMapController controller = await mapController.value!.future;
    await controller.animateCamera(CameraUpdate.newLatLngZoom(location, 16));
  }

  Future<void> upLoadImage() async {
    final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      listImage.value ??= <File>[];
      final List<File> newImages = pickedFiles
          .map((xFile) => File(xFile.path))
          .toList();
      listImage.value = [...listImage.value!, ...newImages];
      listImage.refresh();
    }
  }

  void unDoImage(int index) {
    if (listImage.value != null &&
        index >= 0 &&
        index < listImage.value!.length) {
      final dynamic fileToDelete = listImage.value![index];
      final updatedList = List<dynamic>.from(listImage.value!);
      updatedList.removeAt(index);
      listImage(updatedList);
      listImage.refresh();
      if (fileToDelete is File) {
        _deleteFileIfTemporary(fileToDelete);
      }
    }
  }

  void _deleteFileIfTemporary(File file) {
    final String filePath = file.path.toLowerCase();
    if (filePath.contains('cache') ||
        filePath.contains('tmp') ||
        filePath.contains('temp')) {
      file.deleteSync();
    }
  }

  Future<DateTime?> selectTime(BuildContext context) async {
    ThemeData theme = Theme.of(context);

    return await DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      currentTime: DateTime(
        0,
        0,
        0,
        DateTime.now().hour,
        DateTime.now().minute,
        0,
      ),
      locale: LocaleType.th,
      theme: DatePickerTheme(
        backgroundColor: theme.colorScheme.surfaceContainer,
        itemStyle: theme.textTheme.titleLarge!,
        doneStyle: theme.textTheme.bodyMedium!,
        cancelStyle: theme.textTheme.bodyMedium!,
      ),
    );
  }

  bool _validateForm() {
    if (!formKey.currentState!.validate()) {
      SnackbarUtility.error(
        title: 'ข้อมูลไม่ครบถ้วน',
        message: 'กรุณาตรวจสอบข้อมูลที่กรอกให้ครบถ้วน',
      );
      return false;
    }

    if (listTextController[0].text.trim().isEmpty) {
      SnackbarUtility.error(
        title: 'ข้อมูลไม่ครบถ้วน',
        message: 'กรุณากรอกชื่อโรงพยาบาล',
      );
      return false;
    }

    if (selectedLocation.value == null) {
      SnackbarUtility.error(
        title: 'ข้อมูลไม่ครบถ้วน',
        message: 'กรุณาเลือกตำแหน่งโรงพยาบาลบนแผนที่',
      );
      return false;
    }

    if (listTextController[3].text.trim().isEmpty ||
        listTextController[4].text.trim().isEmpty) {
      SnackbarUtility.error(
        title: 'ข้อมูลไม่ครบถ้วน',
        message: 'กรุณาเลือกเวลาเปิด-ปิด',
      );
      return false;
    }

    return true;
  }

  Future<void> saveHospital() async {
    if (!_validateForm()) return;

    try {
      isLoading(true);

      if (_authService.currentUser.value != null) {
        _hospitalService.createHospital(
          userId: _authService.currentUser.value?.id ?? '',
          title: listTextController[0].text,
          description: listTextController[1].text,
          address: listTextController[2].text,
          latitude: selectedLocation.value?.latitude ?? 0,
          longitude: selectedLocation.value?.longitude ?? 0,
          opening: listTextController[4].text,
          closing: listTextController[5].text,
          images:
              listImage.value
                  ?.whereType<File>()
                  .map((item) => item.path)
                  .toList() ??
              [],
          type: selectedHospitalType.value,
          phoneNumber: listTextController[3].text,
        );
      }
      SnackbarUtility.success(
        title: 'บันทึกสำเร็จ',
        message: 'ข้อมูลโรงพยาบาลถูกบันทึกเรียบร้อยแล้ว',
      );

      _resetForm();
    } catch (e) {
      SnackbarUtility.error(
        title: 'เกิดข้อผิดพลาด',
        message: 'ไม่สามารถบันทึกข้อมูลได้: ${e.toString()}',
      );
    } finally {
      isLoading(false);
    }
  }

  void _resetForm() {
    for (var controller in listTextController) {
      controller.clear();
    }
    markers.value?.clear();
    markers.refresh();
    listImage.value?.clear();
    listImage.refresh();
    selectedLocation.value = null;
    isFocusMap.value = false;
    selectedHospitalType.value = HospitalType.government;
  }

  String getHospitalTypeText(HospitalType type) {
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
  void onClose() {
    for (var controller in listTextController) {
      controller.dispose();
    }
    super.onClose();
  }
}
