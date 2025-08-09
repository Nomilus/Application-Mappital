import 'package:application_mappital/public/model/notification_model.dart';

final mockNotifications = [
  NotificationModel(
    id: 'notification_001',
    title: 'ประชุมด่วน!',
    message: 'มีการประชุมทีมภายในเวลา 15:00 น. ที่ห้องประชุมใหญ่',
    latitude: 13.7563,
    longitude: 100.5018,
    status: NotificationStatus.normal,
    dateTime: DateTime(2025, 8, 8, 14, 30),
  ),
  NotificationModel(
    id: 'notification_002',
    title: 'แจ้งเตือนการชำระเงิน',
    message: 'บิลค่าบริการเดือนสิงหาคมพร้อมให้ชำระแล้ว',
    latitude: 13.7431,
    longitude: 100.5627,
    status: NotificationStatus.danger,
    dateTime: DateTime(2025, 8, 7, 10, 0),
  ),
  NotificationModel(
    id: 'notification_003',
    title: 'โปรโมชั่นพิเศษ!',
    message: 'ส่วนลด 50% สำหรับสินค้าที่คุณสนใจ',
    latitude: 13.7259,
    longitude: 100.5284,
    status: NotificationStatus.normal,
    dateTime: DateTime(2025, 8, 8, 12, 15),
  ),
  NotificationModel(
    id: 'notification_004',
    title: 'อัปเดตแอปพลิเคชัน',
    message: 'มีเวอร์ชันใหม่พร้อมให้ดาวน์โหลดแล้ว',
    latitude: 13.7845,
    longitude: 100.6558,
    status: NotificationStatus.danger,
    dateTime: DateTime(2025, 8, 6, 9, 45),
  ),
];
