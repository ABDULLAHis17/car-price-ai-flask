import 'package:dio/dio.dart';
import '../constants/api_config.dart';
import '../models/car_model.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: ApiConfig.headers,
      ),
    );
  }

  /// الحصول على قائمة أسماء السيارات
  Future<List<String>> getCarNames() async {
    try {
      final response = await _dio.get('/car-names');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return List<String>.from(data['names'] ?? []);
        }
      }
      throw Exception('فشل في تحميل أسماء السيارات');
    } catch (e) {
      throw Exception('خطأ في الاتصال: $e');
    }
  }

  /// الحصول على معلومات السيارات (الفئات)
  Future<CarInfo> getCarInfo() async {
    try {
      final response = await _dio.get('/car-info');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return CarInfo.fromJson(data);
        }
      }
      throw Exception('فشل في تحميل معلومات السيارات');
    } catch (e) {
      throw Exception('خطأ في الاتصال: $e');
    }
  }

  /// التنبؤ بسعر السيارة من صف في البيانات
  Future<PredictionResponse> predictByRow(int rowIndex) async {
    try {
      final response = await _dio.post(
        '/predict-row',
        data: {'row_index': rowIndex},
      );
      if (response.statusCode == 200) {
        return PredictionResponse.fromJson(response.data);
      }
      throw Exception('فشل في التنبؤ');
    } catch (e) {
      throw Exception('خطأ في الاتصال: $e');
    }
  }

  /// التنبؤ بسعر السيارة من إدخال يدوي
  Future<PredictionResponse> predictManual(CarPredictionRequest request) async {
    try {
      final response = await _dio.post(
        '/predict-manual',
        data: request.toJson(),
      );
      if (response.statusCode == 200) {
        return PredictionResponse.fromJson(response.data);
      }
      throw Exception('فشل في التنبؤ');
    } catch (e) {
      throw Exception('خطأ في الاتصال: $e');
    }
  }

  /// فحص صحة الخادم
  Future<bool> healthCheck() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
