import 'package:flutter_shopping_cart_mvvm/domain/stories/cart_store.dart';

class OrderConfirmationViewModel {
  final CartStore _cartStore;

  OrderConfirmationViewModel({required CartStore cartStore})
    : _cartStore = cartStore;

  CartStore get cartStore => _cartStore;

  void dispose() {}
}
