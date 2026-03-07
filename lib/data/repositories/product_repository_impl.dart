import 'package:flutter_shopping_cart_mvvm/data/service/product_service.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/repositories/product_repository.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductService _productService;

  ProductRepositoryImpl({required ProductService productService})
    : _productService = productService;

  @override
  Future<Result<List<ProductEntity>>> getProducts() async {
    return await _productService.getProducts();
  }
}
