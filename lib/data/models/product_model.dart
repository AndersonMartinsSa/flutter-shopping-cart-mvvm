import 'package:flutter_shopping_cart_mvvm/domain/entities/money_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.image,
    required super.category,
    required super.rate,
    required super.count,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: MoneyEntity(value: (json['price'] as num).toDouble()),
      image: json['image'],
      category: json['category'],
      rate: (json['rating']['rate'] as num).toDouble(),
      count: json['rating']['count'],
    );
  }
}
