import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_shopping_cart_mvvm/data/repositories/product_repository_impl.dart';
import 'package:flutter_shopping_cart_mvvm/data/service/product_service.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/exceptions/product_fetch_exception.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/money_entity.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';

class MockProductService extends Mock implements ProductService {}

void main() {
  late ProductRepositoryImpl productRepository;
  late MockProductService mockProductService;

  setUp(() {
    mockProductService = MockProductService();
    productRepository = ProductRepositoryImpl(
      productService: mockProductService,
    );
  });

  group('ProductRepositoryImpl', () {
    final List<ProductEntity> tProductList = [
      ProductEntity(
        id: 1,
        title: "Test Product 1",
        price: MoneyEntity(value: 10.0),
        image: "test_image1.jpg",
        category: "Test Category",
        rate: 4.0,
        count: 100,
      ),
      ProductEntity(
        id: 2,
        title: "Test Product 2",
        price: MoneyEntity(value: 20.0),
        image: "test_image2.jpg",
        category: "Test Category",
        rate: 3.5,
        count: 50,
      ),
    ];

    test(
      'getProducts returns a list of ProductEntity when service call is successful',
      () async {
        when(
          () => mockProductService.getProducts(),
        ).thenAnswer((_) async => Result.ok(tProductList));

        final result = await productRepository.getProducts();

        expect(result, isA<Ok<List<ProductEntity>>>());
        expect((result as Ok<List<ProductEntity>>).value, tProductList);
        verify(() => mockProductService.getProducts()).called(1);
      },
    );

    test('getProducts returns an error when service call fails', () async {
      final tException = ProductFetchException("Failed to fetch products.");
      when(
        () => mockProductService.getProducts(),
      ).thenAnswer((_) async => Result.error(tException));

      final result = await productRepository.getProducts();

      expect(result, isA<Error<List<ProductEntity>>>());
      expect((result as Error<List<ProductEntity>>).appException, tException);
      verify(() => mockProductService.getProducts()).called(1);
    });
  });
}
