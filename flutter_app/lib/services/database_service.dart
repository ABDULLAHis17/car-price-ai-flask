import 'package:dio/dio.dart';
import '../constants/api_config.dart';
import '../models/car_model.dart';
import '../utils/logger.dart';

class DatabaseService {
  late Dio _dio;

  DatabaseService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: ApiConfig.headers,
      ),
    );
  }

  /// الحصول على إحصائيات قاعدة البيانات
  Future<Map<String, dynamic>> getDatabaseStats() async {
    try {
      final response = await _dio.get('/database/stats');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return data['stats'] ?? {};
        }
      }
      throw Exception('فشل في تحميل إحصائيات قاعدة البيانات');
    } catch (e) {
      AppLogger.error('خطأ في getDatabaseStats', e);
      throw Exception('خطأ في الاتصال: $e');
    }
  }

  /// الحصول على جميع السيارات
  Future<List<Map<String, dynamic>>> getAllCars({
    int? limit,
    int offset = 0,
  }) async {
    try {
      final params = {
        if (limit != null) 'limit': limit,
        'offset': offset,
      };

      final response = await _dio.get(
        '/database/cars',
        queryParameters: params,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          final cars = data['cars'] as List;
          return cars.cast<Map<String, dynamic>>();
        }
      }
      throw Exception('فشل في تحميل السيارات');
    } catch (e) {
      AppLogger.error('خطأ في getAllCars', e);
      throw Exception('خطأ في الاتصال: $e');
    }
  }

  /// الحصول على سيارة محددة بواسطة الفهرس
  Future<Map<String, dynamic>> getCarByIndex(int index) async {
    try {
      final response = await _dio.get('/database/car/$index');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return data['car'] ?? {};
        }
      }
      throw Exception('فشل في تحميل السيارة');
    } catch (e) {
      AppLogger.error('خطأ في getCarByIndex', e);
      throw Exception('خطأ في الاتصال: $e');
    }
  }

  /// البحث عن السيارات
  Future<List<Map<String, dynamic>>> searchCars({
    required String query,
    String column = 'name_le',
  }) async {
    try {
      final response = await _dio.get(
        '/database/search',
        queryParameters: {
          'q': query,
          'column': column,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          final results = data['results'] as List;
          return results.cast<Map<String, dynamic>>();
        }
      }
      throw Exception('فشل في البحث');
    } catch (e) {
      AppLogger.error('خطأ في searchCars', e);
      throw Exception('خطأ في الاتصال: $e');
    }
  }

  /// الحصول على نطاق البيانات لعمود معين
  Future<Map<String, dynamic>> getDataRange(String column) async {
    try {
      final response = await _dio.get('/database/range/$column');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return data['range'] ?? {};
        }
      }
      throw Exception('فشل في تحميل نطاق البيانات');
    } catch (e) {
      AppLogger.error('خطأ في getDataRange', e);
      throw Exception('خطأ في الاتصال: $e');
    }
  }

  /// الحصول على عدد السيارات الإجمالي
  Future<int> getTotalCarsCount() async {
    try {
      final response = await _dio.get(
        '/database/cars',
        queryParameters: {'limit': 1},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return data['total'] ?? 0;
        }
      }
      return 0;
    } catch (e) {
      AppLogger.error('خطأ في getTotalCarsCount', e);
      return 0;
    }
  }

  /// الحصول على السيارات بالترقيم (Pagination)
  Future<Map<String, dynamic>> getPaginatedCars({
    required int page,
    required int pageSize,
  }) async {
    try {
      final offset = (page - 1) * pageSize;
      final response = await _dio.get(
        '/database/cars',
        queryParameters: {
          'limit': pageSize,
          'offset': offset,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return {
            'cars': data['cars'] ?? [],
            'total': data['total'] ?? 0,
            'page': page,
            'pageSize': pageSize,
            'totalPages': ((data['total'] ?? 0) / pageSize).ceil(),
          };
        }
      }
      throw Exception('فشل في تحميل البيانات');
    } catch (e) {
      AppLogger.error('خطأ في getPaginatedCars', e);
      throw Exception('خطأ في الاتصال: $e');
    }
  }
}
