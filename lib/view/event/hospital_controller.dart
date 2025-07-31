import 'package:flutter/material.dart';
import 'package:application_mappital/public/model/hospital_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HospitalController extends GetxController {
  IconData iconHospitalType(HospitalType type) {
    switch (type) {
      case HospitalType.government:
        return Icons.account_balance;
      case HospitalType.private:
        return Icons.corporate_fare;
      case HospitalType.university:
        return Icons.school;
      case HospitalType.community:
        return Icons.home_work;
      case HospitalType.clinic:
        return Icons.healing;
      case HospitalType.specialized:
        return Icons.medical_information;
      case HospitalType.militaryPolice:
        return Icons.military_tech;
      case HospitalType.veterinary:
        return Icons.pets;
    }
  }

  String hospitalTypeThai(HospitalType type) {
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

  bool checkTimeInclusive(String start, String end) {
    final format = DateFormat("HH:mm");
    final now = format.parse(format.format(DateTime.now()));
    final startTime = format.parse(start);
    final endTime = format.parse(end);

    if (endTime.isBefore(startTime)) {
      return now.isAfter(startTime) ||
          now.isBefore(endTime) ||
          now == startTime ||
          now == endTime;
    }
    return (now.isAfter(startTime) || now == startTime) &&
        (now.isBefore(endTime) || now == endTime);
  }
}
