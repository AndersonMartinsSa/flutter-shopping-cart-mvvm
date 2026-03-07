import 'package:flutter_shopping_cart_mvvm/domain/entities/money_entity.dart';

class ProductEntity {
  final int _id;
  final String _title;
  final MoneyEntity _price;
  final String _image;
  final String _category;
  final double _rate;
  final int _count;

  ProductEntity({
    required int id,
    required String title,
    required MoneyEntity price,
    required String image,
    required String category,
    required double rate,
    required int count,
  }) : _id = id,
       _title = title,
       _price = price,
       _image = image,
       _category = category,
       _rate = rate,
       _count = count;

  int get id => _id;

  String get title => _title;

  MoneyEntity get price => _price;

  String get image => _image;

  String get category => _category;

  double get rate => _rate;

  int get count => _count;
}
