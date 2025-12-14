class ApiConfig {
  // API Base URL - Geliştirme ortamına göre değiştir
  // Yerel test için: http://192.168.x.x:5000
  // Üretim için: https://your-api-domain.com
  
  // ⚠️ Bunu bilgisayarınızın IP'sine değiştir (örn: http://192.168.1.100:5000)
  static const String baseUrl = 'https://car-price-ai-flask.onrender.com';
  
  // Endpoints
  static const String carNames = '$baseUrl/api/car-names';
  static const String carInfo = '$baseUrl/api/car-info';
  static const String predictRow = '$baseUrl/api/predict-row';
  static const String predictManual = '$baseUrl/api/predict-manual';
  static const String modelInfo = '$baseUrl/api/model-info';
  static const String health = '$baseUrl/api/health';
  static const String databaseStats = '$baseUrl/api/database/stats';
  static const String databaseCars = '$baseUrl/api/database/cars';
  static const String databaseSearch = '$baseUrl/api/database/search';
  
  // Timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
