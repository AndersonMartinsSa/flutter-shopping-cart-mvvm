import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/checkout_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/repositories/checkout_repository.dart';
import 'package:flutter_shopping_cart_mvvm/domain/stories/cart_store.dart';
import 'package:flutter_shopping_cart_mvvm/utils/command.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';

class CartViewModel extends ChangeNotifier {
  final CheckoutRepository _checkoutRepository;
  final CartStore _cartStore;

  CartViewModel({
    required CheckoutRepository checkoutRepository,
    required CartStore cartStore,
  }) : _checkoutRepository = checkoutRepository,
       _cartStore = cartStore {
    checkoutCmd = Command0(_checkout);
  }

  late final Command0 checkoutCmd;

  CartStore get cartStore => _cartStore;

  Future<Result> _checkout() async {
    final Result result = await _checkoutRepository.checkout(
      checkoutEntity: CheckoutEntity(),
    );

    return result;
  }
}
