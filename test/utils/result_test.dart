import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';
import 'package:flutter_shopping_cart_mvvm/domain/exceptions/product_fetch_exception.dart';

void main() {
  group('Result', () {
    test('Result.ok creates an Ok instance with the correct value', () {
      const value = 'Success data';
      final result = Result.ok(value);

      expect(result, isA<Ok<String>>());
      expect((result as Ok<String>).value, value);
    });

    test(
      'Result.error creates an Error instance with the correct AppException',
      () {
        final exception = ProductFetchException('Failed to fetch product');
        final result = Result<int>.error(exception);

        expect(result, isA<Error<int>>());
        expect((result as Error<int>).appException, exception);
      },
    );
  });
}
