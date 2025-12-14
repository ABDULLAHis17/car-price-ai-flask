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

  CarProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await checkServerConnection();
    await loadCarNames();
    await loadCarInfo();
  }

  /// فحص اتصال الخادم
  Future<void> checkServerConnection() async {
    try {
      isServerConnected = await _apiService.healthCheck();
      if (!isServerConnected) {
        errorMessage = 'لم يتمكن من الاتصال بالخادم. تأكد من تشغيل Flask Backend على المنفذ 5000';
      }
      notifyListeners();
    } catch (e) {
      isServerConnected = false;
      errorMessage = 'خطأ في الاتصال: $e';
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
      errorMessage = 'فشل في تحميل أسماء السيارات: $e';
      notifyListeners();
    }
  }

  /// تحميل معلومات السيارات
  Future<void> loadCarInfo() async {
    try {
      carInfo = await _apiService.getCarInfo();
      notifyListeners();
    } catch (e) {
      errorMessage = 'فشل في تحميل معلومات السيارات: $e';
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
      errorMessage = 'خطأ في التنبؤ: $e';
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
      errorMessage = 'خطأ في التنبؤ: $e';
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
