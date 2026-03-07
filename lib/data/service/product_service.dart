import 'package:dio/dio.dart';
import 'package:flutter_shopping_cart_mvvm/data/models/product_model.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/exceptions/product_fetch_exception.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';

abstract class ProductService {
  Future<Result<List<ProductEntity>>> getProducts();
}

class ProductServiceImpl implements ProductService {
  final Dio _dio;

  ProductServiceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<Result<List<ProductEntity>>> getProducts() async {
    try {
      final Response response = await _dio.get("/products");
      if (response.statusCode == 200) {
        final List<ProductModel> products = (response.data as List)
            .map((json) => ProductModel.fromJson(json))
            .toList();

        return Result.ok(products);
      }

      return Result.error(ProductFetchException("Failed to load products."));
    } on Exception catch (_) {
      return Result.error(
        ProductFetchException(
          "An unexpected error occurred while fetching products.",
        ),
      );
    }
  }
}
