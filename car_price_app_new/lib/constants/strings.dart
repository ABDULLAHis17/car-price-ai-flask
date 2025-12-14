class AppStrings {
  // App Info
  static const String appName = '🚗 Araba Fiyatı AI';
  static const String appDescription = 'Akıllı tahmin sistemi ile araç fiyatlarını saniyeler içinde öğrenin';

  // Tabs
  static const String tabRowPrediction = '🔢 Satıra Göre Tahmin';
  static const String tabManualInput = '📝 Manuel Giriş';

  // Row Prediction Screen
  static const String rowPredictionTitle = 'Veri Tabanından Seç';
  static const String rowIndexLabel = 'Satır Numarası (Index)';
  static const String rowIndexHint = '0';
  static const String predictButton = '🎯 Tahmin Et';

  // Manual Input Screen
  static const String manualInputTitle = 'Araç Özelliklerini Girin';
  static const String carNameLabel = '🚙 Araç Adı';
  static const String yearLabel = '📅 Üretim Yılı';
  static const String kmLabel = '🛣️ Kilometre';
  static const String engineLabel = '⚙️ Motor Hacmi';
  static const String powerLabel = '⚡ Maks. Güç';
  static const String mileageLabel = '⛽ Yakıt Tüketimi';
  static const String seatsLabel = '🪑 Koltuk Sayısı';
  static const String fuelLabel = '🔥 Yakıt Türü';
  static const String transmissionLabel = '🔧 Vites Tipi';
  static const String sellerLabel = '🏪 Satıcı Tipi';
  static const String ownerLabel = '👤 Sahip Sayısı';
  static const String submitButton = '🎯 Fiyat Tahmin Et';

  // Result Card
  static const String predictedPriceLabel = '💰 Tahmin Edilen Fiyat';
  static const String realPriceLabel = '📊 Gerçek Fiyat';
  static const String accuracyLabel = 'Doğruluk Oranı';
  static const String successTitle = '✅ Tahmin Edilen Fiyat';

  // Errors
  static const String errorServerConnection = 'تحذير: لم يتمكن من الاتصال بالخادم';
  static const String errorLoadingCarNames = 'فشل في تحميل أسماء السيارات';
  static const String errorLoadingCarInfo = 'فشل في تحميل معلومات السيارات';
  static const String errorPrediction = 'خطأ في التنبؤ';
  static const String errorInvalidInput = 'الرجاء إدخال بيانات صحيحة';
  static const String errorNetworkConnection = 'خطأ في الاتصال بالخادم';

  // Validation Messages
  static const String validationRequired = 'هذا الحقل مطلوب';
  static const String validationInvalidNumber = 'يجب أن يكون رقماً صحيحاً';
  static const String validationInvalidRange = 'القيمة خارج النطاق المسموح';
  static const String validationSelectOption = 'يجب اختيار قيمة';

  // Messages
  static const String messageRefreshing = 'جاري التحديث...';
  static const String messageLoading = 'جاري التحميل...';
  static const String messagePredicting = 'جاري التنبؤ...';
  static const String messageSuccess = 'تم بنجاح!';
  static const String messageError = 'حدث خطأ';

  // Buttons
  static const String buttonRetry = 'إعادة المحاولة';
  static const String buttonCancel = 'إلغاء';
  static const String buttonOK = 'موافق';
  static const String buttonClose = 'إغلاق';
  static const String buttonRefresh = 'تحديث';

  // Status
  static const String statusHealthy = 'سليم';
  static const String statusUnhealthy = 'غير سليم';
  static const String statusLoading = 'جاري التحميل';
  static const String statusError = 'خطأ';
}
