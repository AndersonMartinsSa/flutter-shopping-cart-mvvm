import 'package:dio/dio.dart';
import 'package:flutter_shopping_cart_mvvm/data/repositories/checkout_repository_impl.dart';
import 'package:flutter_shopping_cart_mvvm/data/repositories/product_repository_impl.dart';
import 'package:flutter_shopping_cart_mvvm/data/service/checkout_service.dart';
import 'package:flutter_shopping_cart_mvvm/data/service/product_service.dart';
import 'package:flutter_shopping_cart_mvvm/domain/repositories/checkout_repository.dart';
import 'package:flutter_shopping_cart_mvvm/domain/repositories/product_repository.dart';
import 'package:flutter_shopping_cart_mvvm/domain/stories/cart_store.dart';
import 'package:flutter_shopping_cart_mvvm/ui/cart/cart_viewmodel.dart';
import 'package:flutter_shopping_cart_mvvm/ui/home/home_viewmodel.dart';
import 'package:flutter_shopping_cart_mvvm/ui/order_confirmation/order_confirmation_viewmodel.dart';
import 'package:flutter_shopping_cart_mvvm/utils/environments.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get _viewmodels {
  return [
    ChangeNotifierProvider(
      create: (context) => HomeViewModel(
        productRepository: context.read(),
        cartStore: context.read(),
      ),
    ),
    Provider(
      create: (context) => CartViewModel(
        checkoutRepository: context.read(),
        cartStore: context.read(),
      ),
      dispose: (context, value) => value.dispose(),
    ),
    Provider(
      create: (context) =>
          OrderConfirmationViewModel(cartStore: context.read()),
      dispose: (context, value) => value.dispose(),
    ),
  ];
}

List<SingleChildWidget> get _services {
  return [
    Provider(
      create: (context) =>
          ProductServiceImpl(dio: context.read()) as ProductService,
    ),
    Provider(create: (context) => CheckoutServiceImpl() as CheckoutService),
  ];
}

List<SingleChildWidget> get _repositories {
  return [
    Provider(
      create: (context) =>
          ProductRepositoryImpl(productService: context.read())
              as ProductRepository,
    ),
    Provider(
      create: (context) =>
          CheckoutRepositoryImpl(checkoutService: context.read())
              as CheckoutRepository,
    ),
  ];
}

List<SingleChildWidget> get providers {
  return [
    Provider(
      create: (context) => Dio(BaseOptions(baseUrl: Environments.fakestoreapi)),
    ),
    ChangeNotifierProvider(create: (context) => CartStore.instance),
    ..._services,
    ..._repositories,
    ..._viewmodels,
  ];
}
