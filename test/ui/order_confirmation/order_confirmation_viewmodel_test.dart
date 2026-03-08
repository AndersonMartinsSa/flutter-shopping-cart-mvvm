import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_shopping_cart_mvvm/domain/stories/cart_store.dart';
import 'package:flutter_shopping_cart_mvvm/ui/order_confirmation/order_confirmation_viewmodel.dart';

class MockCartStore extends Mock implements CartStore {}

void main() {
  late OrderConfirmationViewModel orderConfirmationViewModel;
  late MockCartStore mockCartStore;

  setUp(() {
    mockCartStore = MockCartStore();
    orderConfirmationViewModel = OrderConfirmationViewModel(
      cartStore: mockCartStore,
    );
  });

  group('OrderConfirmationViewModel', () {
    test('should expose the provided CartStore instance', () {
      expect(orderConfirmationViewModel.cartStore, mockCartStore);
    });

    test('dispose method does nothing (empty implementation)', () {
      orderConfirmationViewModel.dispose();
    });
  });
}
