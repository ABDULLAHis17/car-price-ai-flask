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
  static const String errorServerConnection = 'Uyarı: Sunucuya bağlanılamadı';
  static const String errorLoadingCarNames = 'Araç adları yüklenemedi';
  static const String errorLoadingCarInfo = 'Araç bilgileri yüklenemedi';
  static const String errorPrediction = 'Tahmin hatası';
  static const String errorInvalidInput = 'Lütfen geçerli veriler girin';
  static const String errorNetworkConnection = 'Sunucu bağlantı hatası';

  // Validation Messages
  static const String validationRequired = 'Bu alan gereklidir';
  static const String validationInvalidNumber = 'Geçerli bir sayı olmalıdır';
  static const String validationInvalidRange = 'Değer izin verilen aralığın dışında';
  static const String validationSelectOption = 'Bir değer seçiniz';

  // Messages
  static const String messageRefreshing = 'Güncelleniyor...';
  static const String messageLoading = 'Yükleniyor...';
  static const String messagePredicting = 'Tahmin ediliyor...';
  static const String messageSuccess = 'Başarılı!';
  static const String messageError = 'Hata oluştu';

  // Buttons
  static const String buttonRetry = 'Yeniden Dene';
  static const String buttonCancel = 'İptal';
  static const String buttonOK = 'Tamam';
  static const String buttonClose = 'Kapat';
  static const String buttonRefresh = 'Yenile';

  // Status
  static const String statusHealthy = 'Sağlıklı';
  static const String statusUnhealthy = 'Sağlıksız';
  static const String statusLoading = 'Yükleniyor';
  static const String statusError = 'Hata';
}
