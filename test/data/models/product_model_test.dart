import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shopping_cart_mvvm/data/models/product_model.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/money_entity.dart';

void main() {
  group('ProductModel', () {
    test('fromJson creates a valid ProductModel from JSON', () {
      final Map<String, dynamic> json = {
        "id": 1,
        "title": "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
        "price": 109.95,
        "description":
            "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
        "category": "men's clothing",
        "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
        "rating": {"rate": 3.9, "count": 120},
      };

      final productModel = ProductModel.fromJson(json);

      expect(productModel.id, 1);
      expect(
        productModel.title,
        "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
      );
      expect(productModel.price.value, 109.95);
      expect(
        productModel.image,
        "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
      );
      expect(productModel.category, "men's clothing");
      expect(productModel.rate, 3.9);
      expect(productModel.count, 120);
      expect(productModel.price, isA<MoneyEntity>());
    });
  });
}
