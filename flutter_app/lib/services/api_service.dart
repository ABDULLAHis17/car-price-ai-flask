import 'package:dio/dio.dart';
import '../constants/api_config.dart';
import '../models/car_model.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: ApiConfig.headers,
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    
    // Add logging interceptor
    _dio.interceptors.add(
      LoggingInterceptor(),
    );
  }

  /// الحصول على قائمة أسماء السيارات
  Future<List<String>> getCarNames() async {
    try {
      final response = await _dio.get('/api/car-names');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return List<String>.from(data['names'] ?? []);
        }
      }
      return [];
    } catch (e) {
      print('Error in getCarNames: $e');
      return [];
    }
  }

  /// الحصول على معلومات السيارات (الفئات)
  Future<CarInfo> getCarInfo() async {
    try {
      final response = await _dio.get('/api/car-info');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return CarInfo.fromJson(data);
        }
      }
      return CarInfo(fuelTypes: [], sellerTypes: [], transmissions: [], ownerCounts: []);
    } catch (e) {
      print('Error in getCarInfo: $e');
      return CarInfo(fuelTypes: [], sellerTypes: [], transmissions: [], ownerCounts: []);
    }
  }

  /// التنبؤ بسعر السيارة من صف في البيانات
  Future<PredictionResponse> predictByRow(int rowIndex) async {
    try {
      final response = await _dio.post(
        '/api/predict-row',
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
        '/api/predict-manual',
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
      print('🔍 Checking health at: ${ApiConfig.baseUrl}/api/health');
      final response = await _dio.get('/api/health');
      print('✅ Health check response: ${response.statusCode} - ${response.data}');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final isHealthy = data['status'] == 'healthy';
        print('✅ Server is healthy: $isHealthy');
        return isHealthy;
      }
      print('❌ Unexpected status code: ${response.statusCode}');
      return false;
    } catch (e) {
      print('❌ Health check error: $e');
      return false;
    }
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('📤 REQUEST: ${options.method} ${options.path}');
    print('📤 Headers: ${options.headers}');
    print('📤 Data: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('📥 RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
    print('📥 Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ ERROR: ${err.message}');
    print('❌ Type: ${err.type}');
    print('❌ Response: ${err.response?.data}');
    super.onError(err, handler);
  }
}
