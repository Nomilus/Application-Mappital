import 'package:application_mappital/public/model/hospital_model.dart';
import 'package:get/get.dart';

class HospitalController extends GetxController {
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
}
