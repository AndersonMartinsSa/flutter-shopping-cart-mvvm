import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_shopping_cart_mvvm/data/repositories/checkout_repository_impl.dart';
import 'package:flutter_shopping_cart_mvvm/data/service/checkout_service.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/checkout_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/exceptions/checkout_exception.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';

class MockCheckoutService extends Mock implements CheckoutService {}

void main() {
  late CheckoutRepositoryImpl checkoutRepository;
  late MockCheckoutService mockCheckoutService;

  setUp(() {
    mockCheckoutService = MockCheckoutService();
    checkoutRepository = CheckoutRepositoryImpl(
      checkoutService: mockCheckoutService,
    );
  });

  group('CheckoutRepositoryImpl', () {
    final CheckoutEntity checkoutEntity = CheckoutEntity();

    test('checkout returns success when service call is successful', () async {
      when(
        () => mockCheckoutService.checkout(checkoutEntity: checkoutEntity),
      ).thenAnswer((_) async => Result.ok({}));

      final result = await checkoutRepository.checkout(
        checkoutEntity: checkoutEntity,
      );

      expect(result, isA<Ok>());
      expect((result as Ok).value, {});
      verify(
        () => mockCheckoutService.checkout(checkoutEntity: checkoutEntity),
      ).called(1);
    });

    test('checkout returns error when service call fails', () async {
      final tException = CheckoutException("Payment failed.");
      when(
        () => mockCheckoutService.checkout(checkoutEntity: checkoutEntity),
      ).thenAnswer((_) async => Result.error(tException));

      final result = await checkoutRepository.checkout(
        checkoutEntity: checkoutEntity,
      );

      expect(result, isA<Error>());
      expect((result as Error).appException, tException);
      verify(
        () => mockCheckoutService.checkout(checkoutEntity: checkoutEntity),
      ).called(1);
    });
  });
}
