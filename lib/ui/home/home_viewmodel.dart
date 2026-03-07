import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/repositories/product_repository.dart';
import 'package:flutter_shopping_cart_mvvm/utils/command.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';

class HomeViewModel extends ChangeNotifier {
  final ProductRepository _productRepository;

  HomeViewModel({required ProductRepository productRepository})
    : _productRepository = productRepository {
    productsCmd = Command0(_getProducts);
    productsCmd.execute();
  }

  late final Command0<List<ProductEntity>> productsCmd;

  Future<Result<List<ProductEntity>>> _getProducts() async {
    await Future.delayed(Duration(seconds: 2));
    final Result<List<ProductEntity>> productsResult = await _productRepository
        .getProducts();

    return productsResult;
  }

  @override
  void dispose() {
    super.dispose();
    productsCmd.dispose();
  }
}
