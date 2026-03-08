import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/money_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_cart_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/exceptions/cart_item_limit_exceeded_exception.dart';
import 'package:flutter_shopping_cart_mvvm/domain/stories/cart_store.dart';

void main() {
  late CartStore cartStore;

  ProductEntity createProduct({
    required int id,
    required String title,
    required double price,
  }) {
    return ProductEntity(
      id: id,
      title: title,
      price: MoneyEntity(value: price),
      image: 'image.jpg',
      category: 'category',
      rate: 4.0,
      count: 100,
    );
  }

  setUp(() {
    CartStore.instance.clear();
    cartStore = CartStore.instance;
  });

  group('CartStore', () {
    final ProductEntity product1 = createProduct(
      id: 1,
      title: 'Product 1',
      price: 10.0,
    );
    final ProductEntity product2 = createProduct(
      id: 2,
      title: 'Product 2',
      price: 20.0,
    );

    group('add', () {
      test('should add a new product to the cart', () {
        cartStore.add(product1);
        expect(cartStore.products.length, 1);
        expect(cartStore.products[0].product.id, product1.id);
        expect(cartStore.products[0].quantity, 1);
        expect(cartStore.totalItems, 1);
        expect(cartStore.totalPrice.value, 10.0);
      });

      test('should increment quantity if product already exists', () {
        cartStore.add(product1);
        cartStore.add(product1);
        expect(cartStore.products.length, 1);
        expect(cartStore.products[0].product.id, product1.id);
        expect(cartStore.products[0].quantity, 2);
        expect(cartStore.totalItems, 2);
        expect(cartStore.totalPrice.value, 20.0);
      });

      test(
        'should throw CartItemLimitExceededException if cart limit is reached',
        () {
          for (int i = 0; i < 10; i++) {
            cartStore.add(
              createProduct(id: i, title: 'Product $i', price: 1.0),
            );
          }
          expect(cartStore.products.length, 10);
          expect(
            () => cartStore.add(
              createProduct(id: 11, title: 'Product 11', price: 1.0),
            ),
            throwsA(isA<CartItemLimitExceededException>()),
          );
        },
      );
    });

    group('remove', () {
      test(
        'should decrement quantity if product quantity is greater than 1',
        () {
          cartStore.add(product1);
          cartStore.add(product1);
          cartStore.remove(product1);
          expect(cartStore.products.length, 1);
          expect(cartStore.products[0].quantity, 1);
          expect(cartStore.totalItems, 1);
          expect(cartStore.totalPrice.value, 10.0);
        },
      );

      test('should remove product from cart if quantity becomes 0', () {
        cartStore.add(product1);
        cartStore.remove(product1);
        expect(cartStore.products.length, 0);
        expect(cartStore.totalItems, 0);
        expect(cartStore.totalPrice.value, 0.0);
      });

      test('should do nothing if product is not in cart', () {
        cartStore.add(product1);
        cartStore.remove(product2);
        expect(cartStore.products.length, 1);
        expect(cartStore.products[0].product.id, product1.id);
        expect(cartStore.totalItems, 1);
      });
    });

    group('clear', () {
      test('should clear all products from the cart', () {
        cartStore.add(product1);
        cartStore.add(product2);
        cartStore.clear();
        expect(cartStore.products.length, 0);
        expect(cartStore.totalItems, 0);
        expect(cartStore.totalPrice.value, 0.0);
      });
    });

    group('removeAllOfProduct', () {
      test('should remove all instances of a specific product', () {
        cartStore.add(product1);
        cartStore.add(product1);
        cartStore.add(product2);
        cartStore.removeAllOfProduct(product1);
        expect(cartStore.products.length, 1);
        expect(cartStore.products[0].product.id, product2.id);
        expect(cartStore.totalItems, 1);
        expect(cartStore.totalPrice.value, 20.0);
      });
    });

    group('getters', () {
      test('totalItems should return the correct total number of items', () {
        cartStore.add(product1);
        cartStore.add(product1);
        cartStore.add(product2);
        expect(cartStore.totalItems, 3);
      });

      test('totalPrice should return the correct total price of products', () {
        cartStore.add(product1);
        cartStore.add(product1);
        cartStore.add(product2);
        expect(cartStore.totalPrice.value, 40.0);
      });

      test(
        'totalCart should return the correct total cart value including shipping',
        () {
          cartStore.add(product1);
          cartStore.add(product2);

          expect(cartStore.totalCart.value, 60.0);
        },
      );
    });

    group('isLastProduct', () {
      test('should return true if it is the last item of a product', () {
        cartStore.add(product1);
        expect(cartStore.isLastProduct(product1), isTrue);
      });

      test('should return false if there are multiple items of a product', () {
        cartStore.add(product1);
        cartStore.add(product1);
        expect(cartStore.isLastProduct(product1), isFalse);
      });

      test(
        'should return false if there are other products with the same id but not the exact same product',
        () {
          final ProductEntity product1_alt = createProduct(
            id: 1,
            title: 'Product 1 Alt',
            price: 15.0,
          );
          cartStore.add(product1);
          cartStore.add(product1_alt);
          expect(cartStore.isLastProduct(product1), isFalse);
        },
      );

      test('should return false if product is not in cart', () {
        expect(cartStore.isLastProduct(product1), isFalse);
      });
    });
  });
}
