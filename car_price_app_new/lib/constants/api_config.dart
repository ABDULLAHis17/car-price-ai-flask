class ApiConfig {
  // API Base URL - تغيير حسب بيئة التطوير
  // للاختبار المحلي: http://192.168.x.x:5000
  // للإنتاج: https://your-api-domain.com
  
  static const String baseUrl = 'http://localhost:5000/api';
  
  // Endpoints
  static const String carNames = '$baseUrl/car-names';
  static const String carInfo = '$baseUrl/car-info';
  static const String predictRow = '$baseUrl/predict-row';
  static const String predictManual = '$baseUrl/predict-manual';
  static const String modelInfo = '$baseUrl/model-info';
  static const String health = '$baseUrl/health';
  
  // Timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
