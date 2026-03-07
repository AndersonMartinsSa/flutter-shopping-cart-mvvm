import 'package:flutter_shopping_cart_mvvm/domain/exceptions/app_exception.dart';

class CartItemLimitExceededException extends AppException {
  CartItemLimitExceededException(super.message);
}
