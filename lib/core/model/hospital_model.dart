import 'package:application_mappital/core/model/image_model.dart';

class HospitalModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String opening;
  final String closing;
  final List<ImageModel> images;
  final HospitalType type;
  final String phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  HospitalModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.opening,
    required this.closing,
    required this.images,
    required this.type,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HospitalModel.fromModel(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      title: json['title'].toString(),
      description: json['description'].toString(),
      address: json['address'].toString(),
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      opening: json['opening'].toString(),
      closing: json['closing'].toString(),
      images: (json['images'] as List)
          .map((item) => ImageModel.fromModel(item))
          .toList(),
      type: _parseHospitalType(json['type'].toString()),
      phoneNumber: json['phone_number'].toString(),
      createdAt: DateTime.parse(json['created_at'].toString()),
      updatedAt: DateTime.parse(json['updated_at'].toString()),
    );
  }

  static HospitalType _parseHospitalType(String type) {
    switch (type) {
      case "GOVERNMENT":
        return HospitalType.government;
      case "PRIVATE":
        return HospitalType.private;
      case "UNIVERSITY":
        return HospitalType.university;
      case "COMMUNITY":
        return HospitalType.community;
      case "CLINIC":
        return HospitalType.clinic;
      case "SPECIALIZED":
        return HospitalType.specialized;
      case "MILITARYPOLICE":
        return HospitalType.militaryPolice;
      case "VETERINARY":
        return HospitalType.veterinary;
      default:
        return HospitalType.government;
    }
  }
}

enum HospitalType {
  government,
  private,
  university,
  community,
  clinic,
  specialized,
  militaryPolice,
  veterinary,
}
