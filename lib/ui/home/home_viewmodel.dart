import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_cart_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/exceptions/cart_item_limit_exceeded_exception.dart';
import 'package:flutter_shopping_cart_mvvm/domain/repositories/product_repository.dart';
import 'package:flutter_shopping_cart_mvvm/domain/stories/cart_store.dart';
import 'package:flutter_shopping_cart_mvvm/utils/command.dart';
import 'package:flutter_shopping_cart_mvvm/utils/result.dart';

class HomeViewModel extends ChangeNotifier {
  final ProductRepository _productRepository;
  final CartStore _cartStore;

  late final Command<List<ProductEntity>> productsCmd; 

  HomeViewModel({
    required ProductRepository productRepository,
    required CartStore cartStore,
    Command<List<ProductEntity>>? productsCommand, 
  }) : _productRepository = productRepository,
       _cartStore = cartStore {
    productsCmd = productsCommand ?? Command0(_getProducts); 
  }

  void getProducts() {
    productsCmd.execute();
  }

  Future<Result<List<ProductEntity>>> _getProducts() async {
    await Future.delayed(Duration(seconds: 2));
    final Result<List<ProductEntity>> productsResult = await _productRepository
        .getProducts();

    return productsResult;
  }

  @override
  void dispose() {
    productsCmd.dispose();
    super.dispose();
  }

  void addProduct({
    required ProductEntity? product,
    required Function(String) onCartItemLimitExceeded,
  }) {
    try {
      _cartStore.add(product!);
      notifyListeners();
    } on CartItemLimitExceededException catch (e) {
      onCartItemLimitExceeded(e.message);
    }
  }

  void removeProduct(ProductEntity product) {
    _cartStore.remove(product);
    notifyListeners();
  }

  ProductCartEntity? getProductInCart(ProductEntity product) {
    final List<ProductCartEntity> productInCart = _cartStore.products
        .where((element) => element.product.id == product.id)
        .toList();

    return productInCart.firstOrNull;
  }
}
