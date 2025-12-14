import 'package:flutter/foundation.dart';

class AppLogger {
  static const String _tag = '🚗 CarPrice';

  /// تسجيل رسالة عادية
  static void info(String message) {
    if (kDebugMode) {
      print('$_tag [INFO] $message');
    }
  }

  /// تسجيل تحذير
  static void warning(String message) {
    if (kDebugMode) {
      print('$_tag [⚠️ WARNING] $message');
    }
  }

  /// تسجيل خطأ
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('$_tag [❌ ERROR] $message');
      if (error != null) {
        print('$_tag Error: $error');
      }
      if (stackTrace != null) {
        print('$_tag StackTrace: $stackTrace');
      }
    }
  }

  /// تسجيل نجاح
  static void success(String message) {
    if (kDebugMode) {
      print('$_tag [✅ SUCCESS] $message');
    }
  }

  /// تسجيل API request
  static void apiRequest(String method, String url, {dynamic body}) {
    if (kDebugMode) {
      print('$_tag [API] $method $url');
      if (body != null) {
        print('$_tag [API] Body: $body');
      }
    }
  }

  /// تسجيل API response
  static void apiResponse(String method, String url, int statusCode, {dynamic body}) {
    if (kDebugMode) {
      print('$_tag [API] $method $url - Status: $statusCode');
      if (body != null) {
        print('$_tag [API] Response: $body');
      }
    }
  }

  /// تسجيل API error
  static void apiError(String method, String url, dynamic error) {
    if (kDebugMode) {
      print('$_tag [API ERROR] $method $url');
      print('$_tag [API ERROR] Error: $error');
    }
  }
}
