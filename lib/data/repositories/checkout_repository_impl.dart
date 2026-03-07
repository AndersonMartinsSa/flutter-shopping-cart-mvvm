import 'package:flutter_shopping_cart_mvvm/data/service/checkout_service.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/checkout_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/repositories/checkout_repository.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutService _checkoutService;

  CheckoutRepositoryImpl({required CheckoutService checkoutService})
    : _checkoutService = checkoutService;

  @override
  Future<Result> checkout({required CheckoutEntity checkoutEntity}) async {
    return await _checkoutService.checkout(checkoutEntity: checkoutEntity);
  }
}
