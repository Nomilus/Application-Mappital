class NotificationModel {
  final String id;
  final String title;
  final String message;
  final double latitude;
  final double longitude;
  final NotificationStatus status;
  final DateTime dateTime;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.dateTime,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      status: _parseNotificationStatus(json['status'] as String),
      dateTime: DateTime.parse(json['date_time'] as String),
    );
  }

  static NotificationStatus _parseNotificationStatus(String typeString) {
    switch (typeString) {
      case 'NORMAL':
        return NotificationStatus.normal;
      case 'DANGER':
        return NotificationStatus.danger;
      default:
        return NotificationStatus.normal;
    }
  }
}

enum NotificationStatus { normal, danger }
