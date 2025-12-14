import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/car_model.dart';

class CarProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // State variables
  List<String> carNames = [];
  CarInfo? carInfo;
  PredictionResponse? lastPrediction;
  
  bool isLoading = false;
  bool isServerConnected = false;
  String? errorMessage;
  bool _initialized = false;

  CarProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_initialized) return;
    _initialized = true;
    
    await checkServerConnection();
    if (isServerConnected) {
      await loadCarNames();
      await loadCarInfo();
    }
  }

  /// فحص اتصال الخادم
  Future<void> checkServerConnection() async {
    try {
      isServerConnected = await _apiService.healthCheck();
      if (!isServerConnected) {
        errorMessage = 'Sunucuya bağlanılamadı. Flask Backend\'in çalıştığından emin olun.';
      }
      notifyListeners();
    } catch (e) {
      isServerConnected = false;
      errorMessage = 'Bağlantı hatası: $e';
      notifyListeners();
    }
  }

  /// تحميل أسماء السيارات
  Future<void> loadCarNames() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      carNames = await _apiService.getCarNames();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'Araç adları yüklenemedi: $e';
      notifyListeners();
    }
  }

  /// تحميل معلومات السيارات
  Future<void> loadCarInfo() async {
    try {
      carInfo = await _apiService.getCarInfo();
      notifyListeners();
    } catch (e) {
      errorMessage = 'Araç bilgileri yüklenemedi: $e';
      notifyListeners();
    }
  }

  /// التنبؤ من صف
  Future<void> predictByRow(int rowIndex) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      lastPrediction = await _apiService.predictByRow(rowIndex);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'Tahmin hatası: $e';
      notifyListeners();
    }
  }

  /// التنبؤ من إدخال يدوي
  Future<void> predictManual(CarPredictionRequest request) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      lastPrediction = await _apiService.predictManual(request);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'Tahmin hatası: $e';
      notifyListeners();
    }
  }

  /// مسح الأخطاء
  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  /// مسح آخر تنبؤ
  void clearPrediction() {
    lastPrediction = null;
    notifyListeners();
  }
}
