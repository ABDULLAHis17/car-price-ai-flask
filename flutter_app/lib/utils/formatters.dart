import 'package:intl/intl.dart';

class Formatters {
  /// Fiyat biçimlendirmesi
  static String formatPrice(double price) {
    final formatter = NumberFormat('#,##0', 'tr_TR');
    return '${formatter.format(price)} ₺';
  }

  /// Büyük sayıları biçimlendirme
  static String formatNumber(num number) {
    final formatter = NumberFormat('#,##0', 'tr_TR');
    return formatter.format(number);
  }

  /// Yüzde biçimlendirmesi
  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }

  /// Tarih biçimlendirmesi
  static String formatDate(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy', 'tr_TR');
    return formatter.format(date);
  }

  /// Saat biçimlendirmesi
  static String formatTime(DateTime time) {
    final formatter = DateFormat('HH:mm:ss', 'tr_TR');
    return formatter.format(time);
  }

  /// Tarih ve saat biçimlendirmesi
  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm:ss', 'tr_TR');
    return formatter.format(dateTime);
  }

  /// Fiyat farkı biçimlendirmesi
  static String formatPriceDifference(double difference) {
    final formatter = NumberFormat('#,##0', 'tr_TR');
    final sign = difference >= 0 ? '+' : '';
    return '$sign${formatter.format(difference)} ₺';
  }

  /// Sayıyı kısaltılmış forma çevirme (örn: 1000 -> 1K)
  static String formatCompactNumber(num number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
