import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/money_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_cart_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/exceptions/cart_item_limit_exceeded_exception.dart';

class CartStore extends ChangeNotifier {
  CartStore._();

  final MoneyEntity shipping = MoneyEntity(value: 30);

  static final CartStore instance = CartStore._();

  final List<ProductCartEntity> _products = [];

  List<ProductCartEntity> get products => _products;

  int get totalItems => _products.fold(0, (sum, e) => sum + e.quantity);

  MoneyEntity get totalPrice => _products.fold(MoneyEntity(value: 0), (sum, e) {
    final double value = sum.value + (e.product.price.value * e.quantity);
    return MoneyEntity(value: value);
  });

  MoneyEntity get totalCart =>
      MoneyEntity(value: totalPrice.value + shipping.value);

  void add(ProductEntity product) {
    final int index = _products.indexWhere(
      (element) => element.product.id == product.id,
    );

    if (index != -1) {
      _products[index].quantity++;
    } else {
      if (_products.length < 10) {
        _products.add(ProductCartEntity(product: product));
      } else {
        throw CartItemLimitExceededException(
          "You have reached the maximum number of items allowed in the cart.",
        );
      }
    }
    notifyListeners();
  }

  void remove(ProductEntity product) {
    final int index = _products.indexWhere(
      (element) => element.product.id == product.id,
    );

    if (index != -1) {
      if (_products[index].quantity > 1) {
        _products[index].quantity--;
      } else {
        _products.removeAt(index);
      }
    }
    notifyListeners();
  }

  bool isLastProduct(ProductEntity product) {
    final List<ProductCartEntity> products = _products
        .where((element) => element.product.id == product.id)
        .toList();
    return products.length == 1 && products.first.quantity == 1;
  }

  void clear() {
    _products.clear();
    notifyListeners();
  }

  void removeAllOfProduct(ProductEntity product) {
    _products.removeWhere((element) => element.product.id == product.id);
    notifyListeners();
  }
}
