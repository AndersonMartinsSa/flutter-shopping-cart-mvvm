import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shopping_cart_mvvm/data/service/checkout_service.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/checkout_entity.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';

void main() {
  late CheckoutServiceImpl checkoutService;

  setUp(() {
    checkoutService = CheckoutServiceImpl();
  });

  group('CheckoutService', () {
    final CheckoutEntity checkoutEntity = CheckoutEntity();

    test('checkout returns Result.ok on successful checkout', () async {
      final result = await checkoutService.checkout(
        checkoutEntity: checkoutEntity,
      );

      expect(result, isA<Ok>());
      expect((result as Ok).value, {});
    });
  });
}
