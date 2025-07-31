class HospitalModel {
  final String id;
  final String creatorId;
  final String title;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String opening;
  final String closing;
  final List<String> images;
  final HospitalType type;
  final String phoneNumber;
  final bool isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  HospitalModel({
    required this.id,
    required this.creatorId,
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
    this.isVerified = false,
    this.createdAt,
    this.updatedAt,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['id'] as String,
      creatorId: json['creatorId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      opening: json['opening'] as String,
      closing: json['closing'] as String,
      images: List<String>.from(json['images'] as List),
      type: _parseHospitalType(json['type'] as String),
      phoneNumber: json['phone_number'] as String,
      isVerified: json['is_verified'] ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  static HospitalType _parseHospitalType(String typeString) {
    switch (typeString) {
      case 'GOVERNMENT':
        return HospitalType.government;
      case 'PRIVATE':
        return HospitalType.private;
      case 'UNIVERSITY':
        return HospitalType.university;
      case 'COMMUNITY':
        return HospitalType.community;
      case 'CLINIC':
        return HospitalType.clinic;
      case 'SPECIALIZED':
        return HospitalType.specialized;
      case 'MILITARYPOLICE':
        return HospitalType.militaryPolice;
      case 'VETERINARY':
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
