import 'package:flutter_shopping_cart_mvvm/domain/entities/checkout_entity.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';

abstract class CheckoutService {
  Future<Result> checkout({required CheckoutEntity checkoutEntity});
}

class CheckoutServiceImpl implements CheckoutService {
  CheckoutServiceImpl();

  @override
  Future<Result> checkout({required CheckoutEntity checkoutEntity}) async {
    await Future.delayed(Duration(seconds: 3));
    // return Result.error(CheckoutException("Payment Failed"));
    return Result.ok({});
  }
}
