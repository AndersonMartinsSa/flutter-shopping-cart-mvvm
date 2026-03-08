import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:flutter_shopping_cart_mvvm/data/service/product_service.dart';
import 'package:flutter_shopping_cart_mvvm/data/models/product_model.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/money_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/exceptions/product_fetch_exception.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late ProductServiceImpl productService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    productService = ProductServiceImpl(dio: mockDio);
  });

  group('ProductService', () {
    final List<Map<String, dynamic>> productsJson = [
      {
        "id": 1,
        "title": "Product 1",
        "price": 10.0,
        "description": "Description 1",
        "category": "Category 1",
        "image": "image1.jpg",
        "rating": {"rate": 4.0, "count": 100},
      },
      {
        "id": 2,
        "title": "Product 2",
        "price": 20.0,
        "description": "Description 2",
        "category": "Category 2",
        "image": "image2.jpg",
        "rating": {"rate": 3.5, "count": 50},
      },
    ];

    test('getProducts returns list of ProductEntity on success', () async {
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/products'),
          data: productsJson,
          statusCode: 200,
        ),
      );

      final result = await productService.getProducts();

      expect(result, isA<Ok<List<ProductEntity>>>());
      expect(
        (result as Ok<List<ProductEntity>>).value,
        isA<List<ProductEntity>>(),
      );
      expect((result).value.length, 2);
      expect((result).value[0].id, 1);
      expect(
        (result).value[0],
        isA<ProductModel>(),
      ); // Ensure it returns ProductModel instances
    });

    test(
      'getProducts returns error when API call fails with non-200 status',
      () async {
        when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/products'),
            data: 'Error',
            statusCode: 404,
          ),
        );

        final result = await productService.getProducts();

        expect(result, isA<Error<List<ProductEntity>>>());
        expect(
          (result as Error<List<ProductEntity>>).appException,
          isA<ProductFetchException>(),
        );
        expect((result).appException.message, "Failed to load products.");
      },
    );

    test('getProducts returns error when an exception occurs', () async {
      when(() => mockDio.get(any())).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/products')),
      );

      final result = await productService.getProducts();

      expect(result, isA<Error<List<ProductEntity>>>());
      expect(
        (result as Error<List<ProductEntity>>).appException,
        isA<ProductFetchException>(),
      );
      expect(
        (result).appException.message,
        "An unexpected error occurred while fetching products.",
      );
    });
  });
}
