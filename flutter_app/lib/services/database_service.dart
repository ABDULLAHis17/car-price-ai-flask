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

  /// Veritabanı istatistiklerini al
  Future<Map<String, dynamic>> getDatabaseStats() async {
    try {
      final response = await _dio.get('/database/stats');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return data['stats'] ?? {};
        }
      }
      throw Exception('Veritabanı istatistikleri yüklenemedi');
    } catch (e) {
      AppLogger.error('getDatabaseStats hatası', e);
      throw Exception('Bağlantı hatası: $e');
    }
  }

  /// Tüm araçları al
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
      throw Exception('Araçlar yüklenemedi');
    } catch (e) {
      AppLogger.error('getAllCars hatası', e);
      throw Exception('Bağlantı hatası: $e');
    }
  }

  /// İndekse göre belirli bir aracı al
  Future<Map<String, dynamic>> getCarByIndex(int index) async {
    try {
      final response = await _dio.get('/database/car/$index');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return data['car'] ?? {};
        }
      }
      throw Exception('Araç yüklenemedi');
    } catch (e) {
      AppLogger.error('getCarByIndex hatası', e);
      throw Exception('Bağlantı hatası: $e');
    }
  }

  /// Araçları ara
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
      throw Exception('Arama başarısız');
    } catch (e) {
      AppLogger.error('searchCars hatası', e);
      throw Exception('Bağlantı hatası: $e');
    }
  }

  /// Belirli bir sütun için veri aralığını al
  Future<Map<String, dynamic>> getDataRange(String column) async {
    try {
      final response = await _dio.get('/database/range/$column');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return data['range'] ?? {};
        }
      }
      throw Exception('Veri aralığı yüklenemedi');
    } catch (e) {
      AppLogger.error('getDataRange hatası', e);
      throw Exception('Bağlantı hatası: $e');
    }
  }

  /// Toplam araç sayısını al
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
      AppLogger.error('getTotalCarsCount hatası', e);
      return 0;
    }
  }

  /// Sayfalanmış araçları al
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
      throw Exception('Veriler yüklenemedi');
    } catch (e) {
      AppLogger.error('getPaginatedCars hatası', e);
      throw Exception('Bağlantı hatası: $e');
    }
  }
}
