import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/money_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_cart_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/exceptions/cart_item_limit_exceeded_exception.dart';
import 'package:flutter_shopping_cart_mvvm/domain/repositories/product_repository.dart';
import 'package:flutter_shopping_cart_mvvm/domain/stories/cart_store.dart';
import 'package:flutter_shopping_cart_mvvm/ui/home/home_viewmodel.dart';
import 'package:flutter_shopping_cart_mvvm/utils/command.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';
import 'package:flutter_shopping_cart_mvvm/domain/exceptions/product_fetch_exception.dart';

class MockProductRepository extends Mock implements ProductRepository {}

class MockCartStore extends Mock implements CartStore {}

class MockCommand<T> extends Mock implements Command<T> {
  @override
  Future<void> execute() => super.noSuchMethod(Invocation.method(#execute, []));

  @override
  Result<T>? get result => super.noSuchMethod(Invocation.getter(#result));

  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []));
}

void main() {
  late HomeViewModel homeViewModel;
  late MockProductRepository mockProductRepository;
  late MockCartStore mockCartStore;
  late MockCommand<List<ProductEntity>> mockProductsCommand;

  setUpAll(() {
    registerFallbackValue(
      ProductEntity(
        id: 1,
        title: 'Fallback Product',
        price: MoneyEntity(value: 0.0),
        image: 'image.jpg',
        category: 'category',
        rate: 0.0,
        count: 0,
      ),
    );
    registerFallbackValue(Result.ok(<ProductEntity>[]));
  });

  setUp(() {
    mockProductRepository = MockProductRepository();
    mockCartStore = MockCartStore();
    mockProductsCommand = MockCommand<List<ProductEntity>>();

    when(() => mockProductsCommand.execute()).thenAnswer((_) async => {});
    when(() => mockProductsCommand.dispose()).thenReturn(null);

    homeViewModel = HomeViewModel(
      productRepository: mockProductRepository,
      cartStore: mockCartStore,
      productsCommand: mockProductsCommand,
    );
  });

  group('HomeViewModel', () {
    final ProductEntity testProduct = ProductEntity(
      id: 1,
      title: 'Test Product',
      price: MoneyEntity(value: 10.0),
      image: 'test_image.jpg',
      category: 'test_category',
      rate: 4.5,
      count: 100,
    );

    final List<ProductEntity> testProducts = [testProduct];

    test('should initialize with productsCmd set up correctly', () {
      expect(homeViewModel.productsCmd, mockProductsCommand);
    });

    group('getProducts', () {
      test('should call productsCmd.execute', () {
        homeViewModel.getProducts();
        verify(() => mockProductsCommand.execute()).called(1);
      });

      test(
        'productsCmd should call productRepository.getProducts and update its result on success',
        () async {
          final realHomeViewModel = HomeViewModel(
            productRepository: mockProductRepository,
            cartStore: mockCartStore,
          );

          when(
            () => mockProductRepository.getProducts(),
          ).thenAnswer((_) async => Result.ok(testProducts));

          await realHomeViewModel.productsCmd.execute();

          verify(() => mockProductRepository.getProducts()).called(1);
          expect(
            realHomeViewModel.productsCmd.result,
            isA<Ok<List<ProductEntity>>>(),
          );
          expect(
            (realHomeViewModel.productsCmd.result as Ok<List<ProductEntity>>)
                .value,
            testProducts,
          );
        },
      );

      test(
        'productsCmd should call productRepository.getProducts and update its result on error',
        () async {
          final exception = ProductFetchException('Failed to fetch');
          final realHomeViewModel = HomeViewModel(
            productRepository: mockProductRepository,
            cartStore: mockCartStore,
          );
          when(
            () => mockProductRepository.getProducts(),
          ).thenAnswer((_) async => Result.error(exception));

          await realHomeViewModel.productsCmd.execute();

          verify(() => mockProductRepository.getProducts()).called(1);
          expect(
            realHomeViewModel.productsCmd.result,
            isA<Error<List<ProductEntity>>>(),
          );
          expect(
            (realHomeViewModel.productsCmd.result as Error<List<ProductEntity>>)
                .appException,
            exception,
          );
        },
      );
    });

    group('addProduct', () {
      test(
        'should add product to cart and notify listeners on success',
        () async {
          when(
            () => mockCartStore.add(any(that: isA<ProductEntity>())),
          ).thenReturn(null);
          when(() => mockCartStore.products).thenReturn([]);

          final listener = MockFunction();
          homeViewModel.addListener(listener);

          homeViewModel.addProduct(
            product: testProduct,
            onCartItemLimitExceeded: (_) {},
          );

          verify(() => mockCartStore.add(testProduct)).called(1);
          verify(() => listener()).called(1);
          homeViewModel.removeListener(listener);
        },
      );

      test(
        'should call onCartItemLimitExceeded callback when CartItemLimitExceededException is thrown',
        () {
          final exception = CartItemLimitExceededException('Limit reached');
          when(
            () => mockCartStore.add(any(that: isA<ProductEntity>())),
          ).thenThrow(exception);

          String capturedMessage = '';
          homeViewModel.addProduct(
            product: testProduct,
            onCartItemLimitExceeded: (message) {
              capturedMessage = message;
            },
          );

          verify(() => mockCartStore.add(testProduct)).called(1);
          expect(capturedMessage, 'Limit reached');
          verifyNever(() => mockCartStore.notifyListeners());
        },
      );
    });

    group('removeProduct', () {
      test('should remove product from cart and notify listeners', () {
        when(
          () => mockCartStore.remove(any(that: isA<ProductEntity>())),
        ).thenReturn(null);
        when(() => mockCartStore.products).thenReturn([]);

        final listener = MockFunction();
        homeViewModel.addListener(listener);

        homeViewModel.removeProduct(testProduct);

        verify(() => mockCartStore.remove(testProduct)).called(1);
        verify(() => listener()).called(1);
        homeViewModel.removeListener(listener);
      });
    });

    group('getProductInCart', () {
      test('should return ProductCartEntity if product is in cart', () {
        final productCartEntity = ProductCartEntity(product: testProduct);
        when(() => mockCartStore.products).thenReturn([productCartEntity]);

        final result = homeViewModel.getProductInCart(testProduct);

        expect(result, productCartEntity);
        verify(() => mockCartStore.products).called(1);
      });

      test('should return null if product is not in cart', () {
        when(() => mockCartStore.products).thenReturn([]);

        final result = homeViewModel.getProductInCart(testProduct);

        expect(result, isNull);
        verify(() => mockCartStore.products).called(1);
      });
    });

    group('dispose', () {
      test('should call productsCmd.dispose', () {
        homeViewModel.dispose();
        verify(() => mockProductsCommand.dispose()).called(1);
      });
    });
  });
}

class MockFunction extends Mock {
  void call();
}
