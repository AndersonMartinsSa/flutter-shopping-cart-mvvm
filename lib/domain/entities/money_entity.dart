import 'package:intl/intl.dart';

final class MoneyEntity {
  final double _value;

  MoneyEntity({required double value}) : _value = value;

  final _formatCurrency = NumberFormat.currency();

  double get value => _value;

  String get formattedValue {
    String price = _formatCurrency.format(value);
    return price;
  }
}

extension MoneyExt on num {
  MoneyEntity toMoney() => MoneyEntity(value: toDouble());
}
