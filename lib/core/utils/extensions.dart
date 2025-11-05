import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toFormattedString({String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(this);
  }

  String toTimeString({String format = 'HH:mm'}) {
    return DateFormat(format).format(this);
  }
}

extension DoubleExtension on double {
  String toCurrencyString({String symbol = 'Rp', int decimalDigits = 2}) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(this);
  }

  String toStringWithDecimal(int digits) {
    return toStringAsFixed(digits);
  }
}

extension IntExtension on int {
  String toCurrencyString({String symbol = 'Rp'}) {
    final formatter = NumberFormat.currency(symbol: symbol, decimalDigits: 0);
    return formatter.format(this);
  }

  String toOrdinal() {
    if (this <= 0) return toString();
    if (this % 100 >= 11 && this % 100 <= 13) return '${this}th';
    switch (this % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }
}

extension StringExtension on String {
  bool isValidEmail() {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  bool isNumeric() {
    return double.tryParse(this) != null;
  }
}

extension ListExtension<T> on List<T> {
  T? getOrNull(int index) {
    try {
      return this[index];
    } catch (e) {
      return null;
    }
  }

  List<T> distinctBy<K>(K Function(T) getKey) {
    final keys = <K>{};
    final list = <T>[];
    for (final item in this) {
      final key = getKey(item);
      if (!keys.contains(key)) {
        keys.add(key);
        list.add(item);
      }
    }
    return list;
  }
}
