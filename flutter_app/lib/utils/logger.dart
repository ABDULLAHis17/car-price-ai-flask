import 'package:flutter/foundation.dart';

class AppLogger {
  static const String _tag = '🚗 CarPrice';

  /// Normal mesaj kaydı
  static void info(String message) {
    if (kDebugMode) {
      print('$_tag [INFO] $message');
    }
  }

  /// Uyarı kaydı
  static void warning(String message) {
    if (kDebugMode) {
      print('$_tag [⚠️ WARNING] $message');
    }
  }

  /// Hata kaydı
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

  /// Başarı kaydı
  static void success(String message) {
    if (kDebugMode) {
      print('$_tag [✅ SUCCESS] $message');
    }
  }

  /// API isteği kaydı
  static void apiRequest(String method, String url, {dynamic body}) {
    if (kDebugMode) {
      print('$_tag [API] $method $url');
      if (body != null) {
        print('$_tag [API] Body: $body');
      }
    }
  }

  /// API yanıtı kaydı
  static void apiResponse(String method, String url, int statusCode, {dynamic body}) {
    if (kDebugMode) {
      print('$_tag [API] $method $url - Status: $statusCode');
      if (body != null) {
        print('$_tag [API] Response: $body');
      }
    }
  }

  /// API hata kaydı
  static void apiError(String method, String url, dynamic error) {
    if (kDebugMode) {
      print('$_tag [API ERROR] $method $url');
      print('$_tag [API ERROR] Error: $error');
    }
  }
}
