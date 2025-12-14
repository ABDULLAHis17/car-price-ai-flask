class Validators {
  /// التحقق من صحة رقم الصف
  static String? validateRowIndex(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الصف مطلوب';
    }
    final index = int.tryParse(value);
    if (index == null) {
      return 'يجب أن يكون رقماً صحيحاً';
    }
    if (index < 0) {
      return 'رقم الصف لا يمكن أن يكون سالباً';
    }
    return null;
  }

  /// التحقق من صحة السنة
  static String? validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'السنة مطلوبة';
    }
    final year = int.tryParse(value);
    if (year == null) {
      return 'يجب أن تكون السنة رقماً صحيحاً';
    }
    if (year < 1990 || year > 2025) {
      return 'السنة يجب أن تكون بين 1990 و 2025';
    }
    return null;
  }

  /// التحقق من صحة الكيلومترات
  static String? validateKilometers(String? value) {
    if (value == null || value.isEmpty) {
      return 'الكيلومترات مطلوبة';
    }
    final km = int.tryParse(value);
    if (km == null) {
      return 'يجب أن يكون الكيلومترات رقماً صحيحاً';
    }
    if (km < 0) {
      return 'الكيلومترات لا يمكن أن تكون سالبة';
    }
    return null;
  }

  /// التحقق من صحة سعة المحرك
  static String? validateEngine(String? value) {
    if (value == null || value.isEmpty) {
      return 'سعة المحرك مطلوبة';
    }
    final engine = int.tryParse(value);
    if (engine == null) {
      return 'يجب أن تكون سعة المحرك رقماً صحيحاً';
    }
    if (engine < 500 || engine > 6000) {
      return 'سعة المحرك يجب أن تكون بين 500 و 6000';
    }
    return null;
  }

  /// التحقق من صحة القوة الحصانية
  static String? validatePower(String? value) {
    if (value == null || value.isEmpty) {
      return 'القوة الحصانية مطلوبة';
    }
    final power = double.tryParse(value);
    if (power == null) {
      return 'يجب أن تكون القوة رقماً صحيحاً';
    }
    if (power < 30 || power > 600) {
      return 'القوة يجب أن تكون بين 30 و 600';
    }
    return null;
  }

  /// التحقق من صحة استهلاك الوقود
  static String? validateMileage(String? value) {
    if (value == null || value.isEmpty) {
      return 'استهلاك الوقود مطلوب';
    }
    final mileage = double.tryParse(value);
    if (mileage == null) {
      return 'يجب أن يكون استهلاك الوقود رقماً صحيحاً';
    }
    if (mileage < 0 || mileage > 60) {
      return 'استهلاك الوقود يجب أن يكون بين 0 و 60';
    }
    return null;
  }

  /// التحقق من صحة عدد المقاعد
  static String? validateSeats(String? value) {
    if (value == null || value.isEmpty) {
      return 'عدد المقاعد مطلوب';
    }
    final seats = int.tryParse(value);
    if (seats == null) {
      return 'يجب أن يكون عدد المقاعد رقماً صحيحاً';
    }
    if (seats < 2 || seats > 10) {
      return 'عدد المقاعد يجب أن يكون بين 2 و 10';
    }
    return null;
  }

  /// التحقق من صحة الاختيار
  static String? validateDropdown(String? value) {
    if (value == null || value.isEmpty) {
      return 'يجب اختيار قيمة';
    }
    return null;
  }
}
