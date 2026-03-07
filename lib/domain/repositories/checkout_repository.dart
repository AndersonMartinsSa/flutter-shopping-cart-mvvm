import 'package:flutter_shopping_cart_mvvm/domain/entities/checkout_entity.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';

abstract class CheckoutRepository {
  Future<Result> checkout({required CheckoutEntity checkoutEntity});
}
