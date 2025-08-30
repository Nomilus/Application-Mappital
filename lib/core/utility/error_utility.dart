import 'package:application_mappital/core/utility/snackbar_utility.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ErrorUtility {
  static void handleGoogleSignInException(
    GoogleSignInException e, {
    bool showCancelMessage = true,
  }) {
    switch (e.code) {
      case GoogleSignInExceptionCode.canceled:
        if (showCancelMessage) {
          SnackbarUtility.error(
            title: 'แจ้งเตือน',
            message: 'การลงชื่อเข้าใช้ถูกยกเลิก',
          );
        }
        break;
      case GoogleSignInExceptionCode.unknownError:
        SnackbarUtility.error(
          title: 'เกิดข้อผิดพลาด Google',
          message: 'การลงชื่อเข้าใช้ล้มเหลว',
        );
        break;
      default:
        SnackbarUtility.error(
          title: 'เกิดข้อผิดพลาด Google',
          message: 'ไม่สามารถลงชื่อเข้าใช้ด้วย Google ได้: ${e.description}',
        );
    }
  }

  static void handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        SnackbarUtility.error(
          title: 'เกิดข้อผิดพลาด Firebase',
          message: 'บัญชีนี้มีอยู่แล้วด้วยข้อมูลประจำตัวอื่น',
        );
        break;
      case 'invalid-credential':
        SnackbarUtility.error(
          title: 'เกิดข้อผิดพลาด Firebase',
          message: 'ข้อมูลประจำตัวไม่ถูกต้อง',
        );
        break;
      case 'user-disabled':
        SnackbarUtility.error(
          title: 'เกิดข้อผิดพลาด Firebase',
          message: 'บัญชีผู้ใช้นี้ถูกปิดใช้งาน',
        );
        break;
      case 'too-many-requests':
        SnackbarUtility.error(
          title: 'เกิดข้อผิดพลาด Firebase',
          message: 'มีการพยายามเข้าสู่ระบบมากเกินไป กรุณาลองใหม่ภายหลัง',
        );
        break;
      case 'operation-not-allowed':
        SnackbarUtility.error(
          title: 'เกิดข้อผิดพลาด Firebase',
          message: 'การลงชื่อเข้าใช้ด้วย Google ไม่ได้รับอนุญาต',
        );
        break;
      default:
        SnackbarUtility.error(
          title: 'เกิดข้อผิดพลาด Firebase',
          message: 'การยืนยันตัวตน Firebase ล้มเหลว: ${e.message}',
        );
    }
  }

  static void handleDioException(DioException e) {
    if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode;
      if (statusCode != null) {
        switch (statusCode) {
          case 400:
            SnackbarUtility.error(
              title: 'เกิดข้อผิดพลาด Dio',
              message: 'คำขอไม่ถูกต้อง',
            );
            break;
          case 401:
            SnackbarUtility.error(
              title: 'เกิดข้อผิดพลาด Dio',
              message: 'ไม่ได้รับอนุญาต กรุณาเข้าสู่ระบบใหม่',
            );
            break;
          case 403:
            SnackbarUtility.error(
              title: 'เกิดข้อผิดพลาด Dio',
              message: 'คุณไม่มีสิทธิ์ในการเข้าถึง',
            );
            break;
          case 404:
            SnackbarUtility.error(
              title: 'เกิดข้อผิดพลาด Dio',
              message: 'ไม่พบข้อมูลที่ร้องขอ',
            );
            break;
          case 500:
            SnackbarUtility.error(
              title: 'เกิดข้อผิดพลาด Dio',
              message: 'เกิดข้อผิดพลาดบนเซิร์ฟเวอร์',
            );
            break;
          default:
            SnackbarUtility.error(
              title: 'เกิดข้อผิดพลาด Dio',
              message: 'เกิดข้อผิดพลาด: ${e.response?.statusCode}',
            );
            break;
        }
      }
    } else if (e.type == DioExceptionType.connectionTimeout) {
      SnackbarUtility.error(
        title: 'เกิดข้อผิดพลาด Dio',
        message: 'หมดเวลาการเชื่อมต่อ กรุณาลองใหม่อีกครั้ง',
      );
    } else if (e.type == DioExceptionType.sendTimeout) {
      SnackbarUtility.error(
        title: 'เกิดข้อผิดพลาด Dio',
        message: 'หมดเวลาส่งข้อมูล',
      );
    } else if (e.type == DioExceptionType.receiveTimeout) {
      SnackbarUtility.error(
        title: 'เกิดข้อผิดพลาด Dio',
        message: 'หมดเวลาการรับข้อมูล',
      );
    } else if (e.type == DioExceptionType.cancel) {
      SnackbarUtility.error(
        title: 'เกิดข้อผิดพลาด Dio',
        message: 'คำขอถูกยกเลิก',
      );
    } else if (e.type == DioExceptionType.connectionError) {
      SnackbarUtility.error(
        title: 'เกิดข้อผิดพลาด Dio',
        message:
            'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อของคุณ',
      );
    }
  }
}
