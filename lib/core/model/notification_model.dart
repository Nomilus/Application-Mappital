import 'package:flutter/rendering.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final double latitude;
  final double longitude;
  final NotificationStatus type;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.createdAt,
  });

  factory NotificationModel.fromModel(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'].toString(),
      title: json['title'].toString(),
      message: json['message'].toString(),
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      type: _parseNotificationStatus(json['type'].toString()),
      createdAt: DateTime.parse(json['created_at'].toString()),
    );
  }

  static NotificationStatus _parseNotificationStatus(String typeString) {
    debugPrint(typeString);
    switch (typeString.toLowerCase()) {
      case 'normal':
        return NotificationStatus.normal;
      case 'danger':
        return NotificationStatus.danger;
      default:
        return NotificationStatus.normal;
    }
  }
}

enum NotificationStatus { normal, danger }
