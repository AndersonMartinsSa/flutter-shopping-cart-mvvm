import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shopping_cart_mvvm/domain/exceptions/app_exception.dart';

class TestAppException extends AppException {
  const TestAppException(super.message);
}

void main() {
  group('AppException', () {
    test('toString returns the correct message', () {
      const errorMessage = 'This is a test error message.';
      const exception = TestAppException(errorMessage);

      expect(exception.message, errorMessage);
      expect(exception.toString(), errorMessage);
    });
  });
}
