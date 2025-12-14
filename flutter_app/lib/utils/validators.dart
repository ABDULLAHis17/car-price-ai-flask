class Validators {
  /// Satır numarası doğrulaması
  static String? validateRowIndex(String? value) {
    if (value == null || value.isEmpty) {
      return 'Satır numarası gereklidir';
    }
    final index = int.tryParse(value);
    if (index == null) {
      return 'Geçerli bir sayı girin';
    }
    if (index < 0) {
      return 'Satır numarası negatif olamaz';
    }
    return null;
  }

  /// Yıl doğrulaması
  static String? validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Yıl gereklidir';
    }
    final year = int.tryParse(value);
    if (year == null) {
      return 'Yıl bir sayı olmalıdır';
    }
    if (year < 1990 || year > 2025) {
      return 'Yıl 1990 ile 2025 arasında olmalıdır';
    }
    return null;
  }

  /// Kilometre doğrulaması
  static String? validateKilometers(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kilometre gereklidir';
    }
    final km = int.tryParse(value);
    if (km == null) {
      return 'Kilometre bir sayı olmalıdır';
    }
    if (km < 0) {
      return 'Kilometre negatif olamaz';
    }
    return null;
  }

  /// Motor hacmi doğrulaması
  static String? validateEngine(String? value) {
    if (value == null || value.isEmpty) {
      return 'Motor hacmi gereklidir';
    }
    final engine = int.tryParse(value);
    if (engine == null) {
      return 'Motor hacmi bir sayı olmalıdır';
    }
    if (engine < 500 || engine > 6000) {
      return 'Motor hacmi 500 ile 6000 arasında olmalıdır';
    }
    return null;
  }

  /// Güç doğrulaması
  static String? validatePower(String? value) {
    if (value == null || value.isEmpty) {
      return 'Güç gereklidir';
    }
    final power = double.tryParse(value);
    if (power == null) {
      return 'Güç bir sayı olmalıdır';
    }
    if (power < 30 || power > 600) {
      return 'Güç 30 ile 600 arasında olmalıdır';
    }
    return null;
  }

  /// Yakıt tüketimi doğrulaması
  static String? validateMileage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Yakıt tüketimi gereklidir';
    }
    final mileage = double.tryParse(value);
    if (mileage == null) {
      return 'Yakıt tüketimi bir sayı olmalıdır';
    }
    if (mileage < 0 || mileage > 60) {
      return 'Yakıt tüketimi 0 ile 60 arasında olmalıdır';
    }
    return null;
  }

  /// Koltuk sayısı doğrulaması
  static String? validateSeats(String? value) {
    if (value == null || value.isEmpty) {
      return 'Koltuk sayısı gereklidir';
    }
    final seats = int.tryParse(value);
    if (seats == null) {
      return 'Koltuk sayısı bir sayı olmalıdır';
    }
    if (seats < 2 || seats > 10) {
      return 'Koltuk sayısı 2 ile 10 arasında olmalıdır';
    }
    return null;
  }

  /// Açılır menü doğrulaması
  static String? validateDropdown(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bir değer seçiniz';
    }
    return null;
  }
}
