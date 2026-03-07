import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';

abstract class ProductRepository {
  Future<Result<List<ProductEntity>>> getProducts();
}