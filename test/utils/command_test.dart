import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_shopping_cart_mvvm/domain/exceptions/product_fetch_exception.dart';
import 'package:flutter_shopping_cart_mvvm/utils/command.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';

class MockCommandAction0<T> extends Mock {
  Future<Result<T>> call();
}

class MockFunction extends Mock {
  void call();
}

void main() {
  group('Command0', () {
    late MockCommandAction0<String> mockAction;
    late Command0<String> command;
    late MockFunction mockListener;

    setUp(() {
      mockAction = MockCommandAction0<String>();
      command = Command0<String>(() => mockAction.call());
      mockListener = MockFunction();
      command.addListener(mockListener);
      clearInteractions(mockListener);
    });

    tearDown(() {
      command.removeListener(mockListener);
    });

    test(
      'execute calls the provided action and updates state on success',
      () async {
        when(
          () => mockAction.call(),
        ).thenAnswer((_) async => Result.ok('Success!'));

        await command.execute();

        expect(command.isRunning, isFalse);
        expect(command.result, isA<Ok<String>>());
        expect(command.value, 'Success!');
        expect(command.error, isFalse);
        expect(command.completed, isTrue);
        verify(() => mockAction.call()).called(1);
        verify(() => mockListener.call()).called(2);
      },
    );

    test(
      'execute calls the provided action and updates state on error',
      () async {
        final exception = ProductFetchException('Failed!');
        when(
          () => mockAction.call(),
        ).thenAnswer((_) async => Result.error(exception));

        await command.execute();

        expect(command.isRunning, isFalse);
        expect(command.result, isA<Error<String>>());
        expect((command.result as Error<String>).appException, exception);
        expect(command.value, isNull);
        expect(command.error, isTrue);
        expect(command.completed, isFalse);
        verify(() => mockAction.call()).called(1);
        verify(() => mockListener.call()).called(2);
      },
    );

    test('cleanResult resets the result and notifies listeners', () async {
      when(() => mockAction.call()).thenAnswer((_) async => Result.ok('Data'));
      await command.execute();
      clearInteractions(mockListener);

      command.cleanResult();

      expect(command.result, isNull);
      expect(command.value, isNull);
      expect(command.error, isFalse);
      expect(command.completed, isFalse);
      verify(() => mockListener.call()).called(1);
    });

    test('execute does not run if already running', () async {
      when(() => mockAction.call()).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 10));
        return Result.ok('Success!');
      });

      command.execute();
      command.execute();

      expect(command.isRunning, isTrue);
      verify(() => mockAction.call()).called(1);

      await Future.delayed(Duration(milliseconds: 20));
      expect(command.isRunning, isFalse);
    });
  });
}
